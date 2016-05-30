{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, autoreconfHook, substituteAll
, file, expat, libdrm, xorg, wayland, libudev, llvmPackages, libffi, libomxil-bellagio
, libvdpau, libelf, libva
, grsecEnabled
, enableTextureFloats ? false # Texture floats are patented, see docs/patents.txt
}:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

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

with { inherit (stdenv.lib) optional optionalString; };

let
  version = "11.2.2";
  # this is the default search path for DRI drivers
  driverLink = "/run/opengl-driver" + optionalString stdenv.isi686 "-32";
in

stdenv.mkDerivation {
  name = "mesa-noglu-${version}";

  src =  fetchurl {
    urls = [
      "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
      (with stdenv.lib; ''ftp://ftp.freedesktop.org/pub/mesa/older-versions/''
        + head (splitString "." version) + ''.x/${version}/mesa-${version}.tar.xz'')
      "https://launchpad.net/mesa/trunk/${version}/+download/mesa-${version}.tar.xz"
    ];
    sha256 = "40e148812388ec7c6d7b6657d5a16e2e8dabba8b97ddfceea5197947647bdfb4";
  };

  prePatch = "patchShebangs .";

  patches = [
    ./glx_ro_text_segm.patch # fix for grsecurity/PaX
    ./symlink-drivers.patch
   # TODO: revive ./dricore-gallium.patch when it gets ported (from Ubuntu),
   #  as it saved ~35 MB in $drivers; watch https://launchpad.net/ubuntu/+source/mesa/+changelog
  ] ++ optional stdenv.isLinux
      (substituteAll {
        src = ./dlopen-absolute-paths.diff;
        libudev = libudev.out;
      });

  postPatch = ''
    substituteInPlace src/egl/main/egldriver.c \
      --replace _EGL_DRIVER_SEARCH_DIR '"${driverLink}"'
  '';

  outputs = [ "dev" "out" "drivers" "osmesa" ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-dri-driverdir=$(drivers)/lib/dri"
    "--with-dri-searchpath=${driverLink}/lib/dri"

    "--enable-gles1"
    "--enable-gles2"
    "--enable-dri"
  ] ++ optional stdenv.isLinux "--enable-dri3"
    ++ [
    "--enable-glx"
    "--enable-gallium-osmesa" # used by wine
    "--enable-egl"
    "--enable-xa" # used in vmware driver
    "--enable-gbm"
  ] ++ optional stdenv.isLinux "--enable-nine" # Direct3D in Wine
    ++ [
    "--enable-xvmc"
    "--enable-vdpau"
    #"--enable-omx"
    #"--enable-va"

    # TODO: Figure out how to enable opencl without having a runtime dependency on clang
    "--disable-opencl"

    (if "armv7l-linux" == stdenv.system
      then null
      else "--with-gallium-drivers=svga,i915,ilo,r300,r600,radeonsi,nouveau,freedreno,swrast")
    "--enable-shared-glapi"
    "--enable-sysfs"
    "--enable-driglx-direct" # seems enabled anyway
    "--enable-glx-tls"
    (if "armv7l-linux" == stdenv.system
      then "--with-dri-drivers="
      else "--with-dri-drivers=i915,i965,nouveau,radeon,r200,swrast")
    "--with-egl-platforms=x11,wayland,drm"

    "--enable-gallium-llvm"
    "--enable-llvm-shared-libs"
  ] ++ optional enableTextureFloats "--enable-texture-float"
    ++ optional grsecEnabled "--enable-glx-rts"; # slight performance degradation, enable only for grsec

  nativeBuildInputs = [ pkgconfig file ];

  propagatedBuildInputs = with xorg; [ libXdamage libXxf86vm ]
    ++ optional stdenv.isLinux libdrm;

  buildInputs = with xorg; [
    autoreconfHook intltool expat llvmPackages.llvm
    glproto dri2proto dri3proto presentproto
    libX11 libXext libxcb libXt libXfixes libxshmfence
    libffi wayland libvdpau libelf libXvMC /* libomxil-bellagio libva */
  ] ++ optional stdenv.isLinux libudev;

  enableParallelBuilding = true;
  doCheck = false;

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM;
  #   also move libOSMesa to $osmesa, as it's relatively big
  # ToDo: probably not all .la files are completely fixed, but it shouldn't matter
  postInstall = with stdenv.lib; ''
    mv -t "$drivers/lib/" \
      $out/lib/libXvMC* \
      $out/lib/d3d \
      $out/lib/vdpau \
      $out/lib/libxatracker*

    mkdir -p {$osmesa,$drivers}/lib/
    mv -t $osmesa/lib/ \
      $out/lib/libOSMesa*

  '' + /* now fix references in .la files */ ''
    sed "/^libdir=/s,$out,$osmesa," -i \
      $osmesa/lib/libOSMesa*.la

  '' + /* set the default search path for DRI drivers; used e.g. by X server */ ''
    substituteInPlace "$dev/lib/pkgconfig/dri.pc" --replace '$(drivers)' "${driverLink}"
  '' + /* move vdpau drivers to $drivers/lib, so they are found */ ''
    mv "$drivers"/lib/vdpau/* "$drivers"/lib/ && rmdir "$drivers"/lib/vdpau
  '';
  #ToDo: @vcunat isn't sure if drirc will be found when in $out/etc/, but it doesn't seem important ATM */

  postFixup =
    # add RPATH so the drivers can find the moved libgallium and libdricore9
    # moved here to avoid problems with stripping patchelfed files
  ''
    for lib in $drivers/lib/*.so* $drivers/lib/*/*.so*; do
      if [[ ! -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):$drivers/lib" "$lib"
      fi
    done
  '';
  # ToDo + /* check $out doesn't depend on llvm */ ''
  # builder failures are ignored for some reason
  #   grep -qv '${llvmPackages.llvm}' -R "$out"

  passthru = { inherit libdrm version driverLink; };

  meta = with stdenv.lib; {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = licenses.mit; # X11 variant, in most files
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ eduarrrd vcunat ];
  };
}
