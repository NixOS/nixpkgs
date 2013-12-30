{ stdenv, fetchurl, pkgconfig, intltool, flex, bison, autoreconfHook
, python, libxml2Python, file, expat, makedepend
, libdrm, xorg, wayland, udev, llvm, libffi
, libvdpau, libelf
, enableTextureFloats ? false # Texture floats are patented, see docs/patents.txt
, enableExtraFeatures ? false # not maintained
}:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

/** Packaging design:
  - The basic mesa ($out) contains headers and libraries (GLU is in mesa_glu now).
    This or the mesa attribute (which also contains GLU) are small (~ 2.2 MB, mostly headers)
    and are designed to be the buildInput of other packages.
  - DRI and EGL drivers are compiled into $drivers output,
    which is bigger (~13 MB) and depends on LLVM (~44 MB).
    These should be searched at runtime in "/run/opengl-driver{,-32}/lib/*"
    and so are kind-of impure (given by NixOS).
    (I suppose on non-NixOS one would create the appropriate symlinks from there.)
  - libOSMesa is in $osmesa (~4.2 MB)
*/

let
  version = "10.0.1";
  # this is the default search path for DRI drivers
  driverLink = "/run/opengl-driver" + stdenv.lib.optionalString stdenv.isi686 "-32";
in
with { inherit (stdenv.lib) optional optionals optionalString; };

stdenv.mkDerivation {
  name = "mesa-noglu-${version}";

  src =  fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    sha256 = "0w1jh8pl4gbzazigsqc5pzc076gckb7b9xgw2w633jlrjn7qdprw";
  };

  prePatch = "patchShebangs .";

  patches = [ # some don't apply -- try without them ATM
    ./static-gallium.patch
   # ./dricore-gallium.patch
   # ./werror-wundef.patch
  ];

  # Change the search path for EGL drivers from $drivers/* to driverLink
  postPatch = ''
    sed '/D_EGL_DRIVER_SEARCH_DIR=/s,EGL_DRIVER_INSTALL_DIR,${driverLink}/lib/egl,' \
      -i src/egl/main/Makefile.am
  '';

  outputs = ["out" "drivers" "osmesa"];

  configureFlags = [
    "--with-dri-driverdir=$(drivers)/lib/dri"
    "--with-egl-driver-dir=$(drivers)/lib/egl"
    "--with-dri-searchpath=${driverLink}/lib/dri"

    "--enable-dri"
    "--enable-glx-tls"
    "--enable-shared-glapi" "--enable-shared-gallium"
    "--enable-driglx-direct" # seems enabled anyway
    "--enable-gallium-llvm" "--with-llvm-shared-libs"
    "--enable-xa" # used in vmware driver
    "--enable-gles1" "--enable-gles2"
    "--enable-vdpau"
    "--enable-osmesa" # used by wine

    "--with-dri-drivers=i965,r200,radeon"
    ("--with-gallium-drivers=i915,nouveau,r300,r600,svga,swrast,radeonsi")
    "--with-egl-platforms=x11,wayland,drm" "--enable-gbm" "--enable-shared-glapi"
  ]
    ++ optional enableTextureFloats "--enable-texture-float"
    ++ optionals enableExtraFeatures [
      "--enable-openvg" "--enable-gallium-egl" # not needed for EGL in Gallium, but OpenVG might be useful
      #"--enable-xvmc" # tests segfault with 9.1.{1,2,3}
      #"--enable-opencl" # ToDo: opencl seems to need libclc for clover
    ];

  nativeBuildInputs = [ pkgconfig python makedepend file flex bison ];

  propagatedBuildInputs = with xorg; [ libXdamage libXxf86vm ]
    ++ optionals stdenv.isLinux [libdrm]
    ;
  buildInputs = with xorg; [
    autoreconfHook intltool expat libxml2Python llvm
    libXfixes glproto dri2proto libX11 libXext libxcb libXt
    libffi wayland libvdpau libelf
  ] ++ optionals enableExtraFeatures [ /*libXvMC*/ ]
    ++ optional stdenv.isLinux udev
    ;

  enableParallelBuilding = true;
  #doCheck = true; # https://bugs.freedesktop.org/show_bug.cgi?id=67672,
    #tests for 10.* fail to link due to some RTTI problem

  # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM;
  #   also move libOSMesa to $osmesa, as it's relatively big
  # ToDo: probably not all .la files are completely fixed, but it shouldn't matter
  postInstall = with stdenv.lib; ''
    mv -t "$drivers/lib/" \
  '' + optionalString enableExtraFeatures ''
      `#$out/lib/libXvMC*` \
      $out/lib/gbm $out/lib/libgbm* \
      $out/lib/gallium-pipe \
  '' + ''
      $out/lib/libdricore* \
      $out/lib/libgallium* \
      $out/lib/vdpau \
      $out/lib/libxatracker*

    mkdir -p {$osmesa,$drivers}/lib/pkgconfig
    mv -t $osmesa/lib/ \
      $out/lib/libOSMesa*

    mv -t $drivers/lib/pkgconfig/ \
      $out/lib/pkgconfig/xatracker.pc

    mv -t $osmesa/lib/pkgconfig/ \
      $out/lib/pkgconfig/osmesa.pc

  '' + /* now fix references in .la files */ ''
    sed "/^libdir=/s,$out,$drivers," -i \
  '' + optionalString enableExtraFeatures ''
      `#$drivers/lib/libXvMC*.la` \
      $drivers/lib/gallium-pipe/*.la \
  '' + ''
      $drivers/lib/libgallium.la \
      $drivers/lib/vdpau/*.la \
      $drivers/lib/libdricore*.la

    sed "s,$out\(/lib/\(libdricore[0-9\.]*\|libgallium\).la\),$drivers\1,g" \
      -i $drivers/lib/*.la $drivers/lib/*/*.la

    sed "/^libdir=/s,$out,$osmesa," -i \
      $osmesa/lib/libOSMesa*.la

  '' + /* work around bug #529, but maybe $drivers should also be patchelf-ed */ ''
    find $drivers/ $osmesa/ -type f -executable -print0 | xargs -0 strip -S || true

  '' + /* add RPATH so the drivers can find the moved libgallium and libdricore9 */ ''
    for lib in $drivers/lib/*.so* $drivers/lib/*/*.so*; do
      if [[ ! -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):$drivers/lib" "$lib"
      fi
    done
  '' + /* set the default search path for DRI drivers; used e.g. by X server */ ''
    substituteInPlace "$out/lib/pkgconfig/dri.pc" --replace '$(drivers)' "${driverLink}"
  '' + /* move vdpau drivers to $drivers/lib, so they are found */ ''
    mv "$drivers"/lib/vdpau/* "$drivers"/lib/ && rmdir "$drivers"/lib/vdpau
  '';
  #ToDo: @vcunat isn't sure if drirc will be found when in $out/etc/, but it doesn't seem important ATM

  passthru = { inherit libdrm version driverLink; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = with stdenv.lib.maintainers; [ simons vcunat ];
  };
}
