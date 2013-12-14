{ stdenv, fetchurl, pkgconfig, intltool, flex, bison, autoconf, automake, libtool
, python, libxml2Python, file, expat, makedepend
, libdrm, xorg, wayland, udev, llvm, libffi
, libvdpau
, enableTextureFloats ? false # Texture floats are patented, see docs/patents.txt
, enableR600LlvmCompiler ? false # current llvm-3.3 + mesa-9.1.6 don't configure
, enableExtraFeatures ? false # add ~15 MB to mesa_drivers
}:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

/** Packaging design:
  - The basic mesa ($out) contains headers and libraries (GLU is in mesa_glu now).
    This or the mesa attribute (which also contains GLU) are small (~ 2.2 MB, mostly headers)
    and are designed to be the buildInput of other packages.
  - DRI and EGL drivers are compiled into $drivers output,
    which is bigger (~13 MB) and depends on LLVM (~40 MB).
    These should be searched at runtime in /run/current-system/sw/lib/*
    and so are kind-of impure (given by NixOS).
    (I suppose on non-NixOS one would create the appropriate symlinks from there.)
*/

let
  version = "9.1.7";
  # this is the default search path for DRI drivers (note: X server introduces an overriding env var)
  driverLink = "/run/opengl-driver" + stdenv.lib.optionalString stdenv.isi686 "-32";
in
stdenv.mkDerivation {
  name = "mesa-noglu-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    sha256 = "1824p185ys7z9bah46xasp7khv44n9wv2c4p38i1dispniwbirih";
  };

  prePatch = "patchShebangs .";

  patches = [
    ./static-gallium.patch
    ./dricore-gallium.patch
    ./fix-rounding.patch
  ];

  # Change the search path for EGL drivers from $drivers/* to driverLink
  postPatch = ''
    sed '/D_EGL_DRIVER_SEARCH_DIR=/s,EGL_DRIVER_INSTALL_DIR,${driverLink}/lib/egl,' \
      -i src/egl/main/Makefile.am
  '';

  outputs = ["out" "drivers"];

  preConfigure = "./autogen.sh";

  configureFlags = with stdenv.lib; [
    "--with-dri-driverdir=$(drivers)/lib/dri"
    "--with-egl-driver-dir=$(drivers)/lib/egl"
    "--with-dri-searchpath=${driverLink}/lib/dri"

    "--enable-dri"
    "--enable-glx-tls"
    "--enable-shared-glapi" "--enable-shared-gallium"
    "--enable-driglx-direct" # seems enabled anyway
    "--enable-gallium-llvm" "--with-llvm-shared-libs"
    "--enable-xa" # used in vmware driver

    "--with-dri-drivers=i965,r200,radeon"
    "--with-gallium-drivers=i915,nouveau,r300,r600,svga,swrast" # radeonsi complains about R600 missing in LLVM
    "--with-egl-platforms=x11,wayland,drm" "--enable-gbm" "--enable-shared-glapi"
  ]
    ++ optional enableR600LlvmCompiler "--enable-r600-llvm-compiler" # complains about R600 missing in LLVM
    ++ optional enableTextureFloats "--enable-texture-float"
    ++ optionals enableExtraFeatures [
      "--enable-gles1" "--enable-gles2"
      "--enable-osmesa"
      "--enable-openvg" "--enable-gallium-egl" # not needed for EGL in Gallium, but OpenVG might be useful
      #"--enable-xvmc" # tests segfault with 9.1.{1,2,3}
      "--enable-vdpau"
      #"--enable-opencl" # ToDo: opencl seems to need libclc for clover
    ];

  nativeBuildInputs = [ pkgconfig python makedepend file flex bison ];

  propagatedBuildInputs = with xorg; [ libXdamage libXxf86vm ]
  ++
  stdenv.lib.optionals stdenv.isLinux [libdrm]
  ;
  buildInputs = with xorg; [
    autoconf automake libtool intltool expat libxml2Python llvm
    libXfixes glproto dri2proto libX11 libXext libxcb libXt
    libffi wayland
  ] ++ stdenv.lib.optionals enableExtraFeatures [ /*libXvMC*/ libvdpau ]
  ++ stdenv.lib.optional stdenv.isLinux [udev]
  ;

  enableParallelBuilding = true;
  doCheck = true;

  # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM
  # ToDo: probably not all .la files are completely fixed, but it shouldn't matter
  postInstall = with stdenv.lib; ''
    mv -t "$drivers/lib/" \
  '' + optionalString enableExtraFeatures ''
      `#$out/lib/libXvMC*` \
      $out/lib/vdpau \
      $out/lib/libOSMesa* \
      $out/lib/gbm $out/lib/libgbm* \
      $out/lib/gallium-pipe \
  '' + ''
      $out/lib/libdricore* \
      $out/lib/libgallium* \
      $out/lib/libxatracker*

  '' + /* now fix references in .la files */ ''
    sed "/^libdir=/s,$out,$drivers," -i \
  '' + optionalString enableExtraFeatures ''
      `#$drivers/lib/libXvMC*.la` \
      $drivers/lib/vdpau/*.la \
      $drivers/lib/libOSMesa*.la \
      $drivers/lib/gallium-pipe/*.la \
  '' + ''
      $drivers/lib/libgallium.la \
      $drivers/lib/libdricore*.la

    sed "s,$out\(/lib/\(libdricore[0-9\.]*\|libgallium\).la\),$drivers\1,g" \
      -i $drivers/lib/*.la $drivers/lib/*/*.la

  '' + /* work around bug #529, but maybe $drivers should also be patchelf-ed */ ''
    find $drivers/ -type f -executable -print0 | xargs -0 strip -S || true

  '' + /* add RPATH so the drivers can find the moved libgallium and libdricore9 */ ''
    for lib in $drivers/lib/*.so* $drivers/lib/*/*.so*; do
      if [[ ! -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):$drivers/lib" "$lib"
      fi
    done
  '' + /* set the default search path for DRI drivers; used e.g. by X server */ ''
    substituteInPlace "$out/lib/pkgconfig/dri.pc" --replace '$(drivers)' "${driverLink}"
  '';
  #ToDo: @vcunat isn't sure if drirc will be found when in $out/etc/, but it doesn't seem important ATM

  passthru = { inherit libdrm version driverLink; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
