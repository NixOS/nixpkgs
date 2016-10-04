{ stdenv, fetchurl, fetchpatch
, pkgconfig, intltool, autoreconfHook, substituteAll
, file, expat, libdrm, xorg, wayland, systemd
, llvmPackages, libffi, libomxil-bellagio, libva
, libelf, libvdpau, python
, grsecEnabled ? false
, enableTextureFloats ? false # Texture floats are patented, see docs/patents.txt
}:


/** Packaging design:
  - The basic mesa ($out) contains headers and libraries (GLU is in mesa_glu now).
    This or the mesa attribute (which also contains GLU) are small (~ 2 MB, mostly headers)
    and are designed to be the buildInput of other packages.
  - DRI drivers are compiled into $drivers output, which is much bigger and
    depends on LLVM. These should be searched at runtime in
    "/run/opengl-driver{,-32}/lib/*" and so are kind-of impure (given by NixOS).
    (I suppose on non-NixOS one would create the appropriate symlinks from there.)
  - libOSMesa is in $osmesa (~4 MB)
*/

with stdenv.lib;

if ! lists.elem stdenv.system platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

let
  version = "12.0.2";
  branch  = head (splitString "." version);
  driverLink = "/run/opengl-driver" + optionalString stdenv.isi686 "-32";
in

stdenv.mkDerivation {
  name = "mesa-noglu-${version}";

  src =  fetchurl {
    urls = [
      "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/older-versions/${branch}.x/${version}/mesa-${version}.tar.xz"
      "https://launchpad.net/mesa/trunk/${version}/+download/mesa-${version}.tar.xz"
    ];
    sha256 = "d957a5cc371dcd7ff2aa0d87492f263aece46f79352f4520039b58b1f32552cb";
  };

  prePatch = "patchShebangs .";

  # TODO:
  #  revive ./dricore-gallium.patch when it gets ported (from Ubuntu), as it saved
  #  ~35 MB in $drivers; watch https://launchpad.net/ubuntu/+source/mesa/+changelog
  patches = [
    ./glx_ro_text_segm.patch # fix for grsecurity/PaX
    ./symlink-drivers.patch
  ] ++ optional stdenv.isLinux
      (substituteAll {
        src = ./dlopen-absolute-paths.diff;
        libudev = systemd.lib;
      });

  postPatch = ''
    substituteInPlace src/egl/main/egldriver.c \
      --replace _EGL_DRIVER_SEARCH_DIR '"${driverLink}"'
  '';

  outputs = [ "out" "dev" "drivers" "osmesa" ];

  # TODO: Figure out how to enable opencl without having a runtime dependency on clang
  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-dri-driverdir=$(drivers)/lib/dri"
    "--with-dri-searchpath=${driverLink}/lib/dri"
    "--with-egl-platforms=x11,wayland,drm"
    (optionalString (stdenv.system != "armv7l-linux")
      "--with-gallium-drivers=svga,i915,ilo,r300,r600,radeonsi,nouveau,freedreno,swrast")
    (optionalString (stdenv.system != "armv7l-linux")
      "--with-dri-drivers=i915,i965,nouveau,radeon,r200,swrast")

    (enableFeature enableTextureFloats "texture-float")
    (enableFeature grsecEnabled "glx-rts")
    (enableFeature stdenv.isLinux "dri3")
    (enableFeature stdenv.isLinux "nine") # Direct3D in Wine
    "--enable-dri"
    "--enable-driglx-direct"
    "--enable-gles1"
    "--enable-gles2"
    "--enable-glx"
    "--enable-glx-tls"
    "--enable-gallium-osmesa" # used by wine
    "--enable-gallium-llvm"
    "--enable-egl"
    "--enable-xa" # used in vmware driver
    "--enable-gbm"
    "--enable-xvmc"
    "--enable-vdpau"
    "--enable-shared-glapi"
    "--enable-sysfs"
    "--enable-llvm-shared-libs"
    "--enable-omx"
    "--enable-va"
    "--disable-opencl"
  ];

  nativeBuildInputs = [ pkgconfig file ];

  propagatedBuildInputs = with xorg;
    [ libXdamage libXxf86vm ]
    ++ optional stdenv.isLinux libdrm;

  buildInputs = with xorg; [
    autoreconfHook intltool expat llvmPackages.llvm
    glproto dri2proto dri3proto presentproto
    libX11 libXext libxcb libXt libXfixes libxshmfence
    libffi wayland libvdpau libelf libXvMC
    libomxil-bellagio libva libpthreadstubs
    (python.withPackages (ps: [ ps.Mako ]))
  ] ++ optional stdenv.isLinux systemd;


  enableParallelBuilding = true;
  doCheck = false;

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  # TODO: probably not all .la files are completely fixed, but it shouldn't matter;
  postInstall = ''
    # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM
    mv -t "$drivers/lib/"    \
      $out/lib/libXvMC*      \
      $out/lib/d3d           \
      $out/lib/vdpau         \
      $out/lib/bellagio      \
      $out/lib/libxatracker* \

    mv $out/lib/dri/* $drivers/lib/dri

    # move libOSMesa to $osmesa, as it's relatively big
    mkdir -p {$osmesa,$drivers}/lib/
    mv -t $osmesa/lib/ $out/lib/libOSMesa*

    # now fix references in .la files
    sed "/^libdir=/s,$out,$osmesa," -i $osmesa/lib/libOSMesa*.la

    # set the default search path for DRI drivers; used e.g. by X server
    substituteInPlace "$dev/lib/pkgconfig/dri.pc" --replace '$(drivers)' "${driverLink}"
  '';

  # TODO:
  #  @vcunat isn't sure if drirc will be found when in $out/etc/;
  #  check $out doesn't depend on llvm: builder failures are ignored
  #  for some reason grep -qv '${llvmPackages.llvm}' -R "$out";
  postFixup = ''
    # add RPATH so the drivers can find the moved libgallium and libdricore9
    # moved here to avoid problems with stripping patchelfed files
    for lib in $drivers/lib/*.so* $drivers/lib/*/*.so*; do
      if [[ ! -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):$drivers/lib" "$lib"
      fi
    done
  '';

  passthru = { inherit libdrm version driverLink; };

  meta = with stdenv.lib; {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = licenses.mit; # X11 variant, in most files
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ eduarrrd vcunat ];
  };
}
