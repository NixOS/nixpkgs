{ stdenv, fetchurl, lib
, pkgconfig, intltool, autoreconfHook
, file, expat, libdrm, xorg, wayland, wayland-protocols, openssl
, llvmPackages, libffi, libomxil-bellagio, libva-minimal
, libelf, libvdpau, python2, python2Packages
, libglvnd
, enableRadv ? true
, galliumDrivers ? null
, driDrivers ? null
, vulkanDrivers ? null
, eglPlatforms ? [ "x11" ] ++ lib.optionals stdenv.isLinux [ "wayland" "drm" ]
, OpenGL, Xplugin
, withValgrind ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAarch32, valgrind-light
}:

/** Packaging design:
  - The basic mesa ($out) contains headers and libraries (GLU is in libGLU now).
    This or the mesa attribute (which also contains GLU) are small (~ 2 MB, mostly headers)
    and are designed to be the buildInput of other packages.
  - DRI drivers are compiled into $drivers output, which is much bigger and
    depends on LLVM. These should be searched at runtime in
    "/run/opengl-driver{,-32}/lib/*" and so are kind-of impure (given by NixOS).
    (I suppose on non-NixOS one would create the appropriate symlinks from there.)
  - libOSMesa is in $osmesa (~4 MB)
*/

with stdenv.lib;

let
  # platforms that have PCIe slots and thus can use most non-integrated GPUs
  pciePlatform = !stdenv.hostPlatform.isAarch32 && !stdenv.hostPlatform.isAarch64;
  defaultGalliumDrivers = optionals (elem "drm" eglPlatforms) ([ "virgl" ]
    ++ lib.optionals pciePlatform [ "r300" "r600" "radeonsi" ]
    ++ lib.optionals (pciePlatform || stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) [ "nouveau" ]
    ++ lib.optionals stdenv.hostPlatform.isx86 [ "i915" "svga" ]
    ++ lib.optionals (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) [ "vc4" ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "freedreno" "etnaviv" "imx" ]
  );
  defaultDriDrivers = optionals (elem "drm" eglPlatforms) ([ ]
    ++ lib.optionals pciePlatform [ "radeon" "r200" ]
    ++ lib.optionals (pciePlatform || stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) [ "nouveau" ]
    ++ lib.optionals stdenv.hostPlatform.isx86 [ "i915" "i965" ]);
  defaultVulkanDrivers = optionals stdenv.hostPlatform.isLinux ([ ]
    ++ lib.optional stdenv.hostPlatform.isx86 "intel"
    ++ lib.optional enableRadv "radeon");
in

let gallium_ = galliumDrivers; dri_ = driDrivers; vulkan_ = vulkanDrivers; in

let
  galliumDrivers =
    (if gallium_ == null
          then defaultGalliumDrivers
          else gallium_)
    ++ lib.optional stdenv.isLinux "swrast";
  driDrivers =
    (if dri_ == null
      then optionals (elem "drm" eglPlatforms) defaultDriDrivers
      else dri_) ++ lib.optional stdenv.isLinux "swrast";
  vulkanDrivers =
    if vulkan_ == null
    then defaultVulkanDrivers
    else vulkan_;
in

let
  version = "18.3.4";
  branch  = head (splitString "." version);
in

let self = stdenv.mkDerivation {
  name = "mesa-${version}";

  src =  fetchurl {
    urls = [
      "ftp://ftp.freedesktop.org/pub/mesa/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/older-versions/${branch}.x/${version}/mesa-${version}.tar.xz"
      "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz"
    ];
    sha256 = "01xv03ah4l5lcfx015n3fg1620dh4nbbv6gmhh6zhdsx6sj4sc9j";
  };

  prePatch = "patchShebangs .";

  # TODO:
  #  revive ./dricore-gallium.patch when it gets ported (from Ubuntu), as it saved
  #  ~35 MB in $drivers; watch https://launchpad.net/ubuntu/+source/mesa/+changelog
  patches = [
    ./symlink-drivers.patch
    ./missing-includes.patch # dev_t needs sys/stat.h, time_t needs time.h, etc.-- fixes build w/musl
    ./disk_cache-include-dri-driver-path-in-cache-key.patch
  ];

  outputs = [ "out" "dev" "drivers" ]
            ++ lib.optional (elem "swrast" galliumDrivers) "osmesa";

  # TODO: Figure out how to enable opencl without having a runtime dependency on clang
  configureFlags = [
    "--sysconfdir=${libglvnd.driverLink}/etc"
    "--localstatedir=/var"
    "--with-dri-driverdir=$(drivers)/lib/dri"
    "--with-dri-searchpath=${libglvnd.driverLink}/lib/dri"
    "--with-platforms=${concatStringsSep "," eglPlatforms}"
    "--with-gallium-drivers=${concatStringsSep "," galliumDrivers}"
    "--with-dri-drivers=${concatStringsSep "," driDrivers}"
    "--with-vulkan-drivers=${concatStringsSep "," vulkanDrivers}"
    "--enable-texture-float"
    (enableFeature stdenv.isLinux "dri3")
    (enableFeature stdenv.isLinux "nine") # Direct3D in Wine
    (enableFeature stdenv.isLinux "libglvnd")
    "--enable-dri"
    "--enable-driglx-direct"
    "--enable-gles1"
    "--enable-gles2"
    "--enable-glx"
    # https://bugs.freedesktop.org/show_bug.cgi?id=35268
    (enableFeature (!stdenv.hostPlatform.isMusl) "glx-tls")
    # used by wine
    (enableFeature (elem "swrast" galliumDrivers) "gallium-osmesa")
    "--enable-llvm"
    (enableFeature stdenv.isLinux "egl")
    (enableFeature stdenv.isLinux "xa") # used in vmware driver
    (enableFeature stdenv.isLinux "gbm")
    "--enable-xvmc"
    "--enable-vdpau"
    "--enable-shared-glapi"
    "--enable-llvm-shared-libs"
    (enableFeature stdenv.isLinux "omx-bellagio")
    (enableFeature stdenv.isLinux "va")
    "--disable-opencl"
  ];

  nativeBuildInputs = [
    autoreconfHook intltool pkgconfig file
    python2 python2Packages.Mako
  ];

  propagatedBuildInputs = with xorg; [
    libXdamage libXxf86vm
  ] ++ optional stdenv.isLinux libdrm
    ++ optionals stdenv.isDarwin [ OpenGL Xplugin ];

  buildInputs = with xorg; [
    expat llvmPackages.llvm libglvnd xorgproto
    libX11 libXext libxcb libXt libXfixes libxshmfence libXrandr
    libffi libvdpau libelf libXvMC
    libpthreadstubs openssl /*or another sha1 provider*/
  ] ++ lib.optionals (elem "wayland" eglPlatforms) [ wayland wayland-protocols ]
    ++ lib.optionals stdenv.isLinux [ libomxil-bellagio libva-minimal ]
    ++ lib.optional withValgrind valgrind-light;

  enableParallelBuilding = true;
  doCheck = false;

  installFlags = [
    "sysconfdir=\${drivers}/etc"
    "localstatedir=\${TMPDIR}"
    "vendorjsondir=\${out}/share/glvnd/egl_vendor.d"
  ];

  # TODO: probably not all .la files are completely fixed, but it shouldn't matter;
  postInstall = ''
    # Some installs don't have any drivers so this directory is never created.
    mkdir -p $drivers
  '' + optionalString (galliumDrivers != []) ''
    # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM
    mv -t "$drivers/lib/"    \
      $out/lib/libXvMC*      \
      $out/lib/d3d           \
      $out/lib/vdpau         \
      $out/lib/bellagio      \
      $out/lib/libxatracker* \
      $out/lib/libvulkan_*

    # Move other drivers to a separate output
    mv $out/lib/dri/* $drivers/lib/dri # */
    rmdir "$out/lib/dri"
    mv $out/lib/lib*_mesa* $drivers/lib

    # move libOSMesa to $osmesa, as it's relatively big
    mkdir -p {$osmesa,$drivers}/lib/
    mv -t $osmesa/lib/ $out/lib/libOSMesa*

    # now fix references in .la files
    sed "/^libdir=/s,$out,$osmesa," -i $osmesa/lib/libOSMesa*.la

    # set the default search path for DRI drivers; used e.g. by X server
    substituteInPlace "$dev/lib/pkgconfig/dri.pc" --replace '$(drivers)' "${libglvnd.driverLink}"

    # remove GLES libraries; they are provided by libglvnd
    rm $out/lib/lib{GLESv1_CM,GLESv2}.*

    # remove pkgconfig files for GL/GLES/EGL; they are provided by libGL.
    rm $dev/lib/pkgconfig/{gl,egl,glesv1_cm,glesv2}.pc

    # move vendor files
    mv $out/share/ $drivers/

    # Update search path used by glvnd
    for js in $drivers/share/glvnd/egl_vendor.d/*.json; do
      substituteInPlace "$js" --replace '"libEGL_' '"'"$drivers/lib/libEGL_"
    done

    # Update search path used by pkg-config
    for pc in $dev/lib/pkgconfig/{d3d,dri,xatracker}.pc; do
      substituteInPlace "$pc" --replace $out $drivers
    done
  '' + optionalString (vulkanDrivers != []) ''
    # Update search path used by Vulkan (it's pointing to $out but
    # drivers are in $drivers)
    for js in $drivers/share/vulkan/icd.d/*.json; do
      substituteInPlace "$js" --replace "$out" "$drivers"
    done
  '';

  # TODO:
  #  check $out doesn't depend on llvm: builder failures are ignored
  #  for some reason grep -qv '${llvmPackages.llvm}' -R "$out";
  postFixup = optionalString (galliumDrivers != []) ''
    # add RPATH so the drivers can find the moved libgallium and libdricore9
    # moved here to avoid problems with stripping patchelfed files
    for lib in $drivers/lib/*.so* $drivers/lib/*/*.so*; do
      if [[ ! -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):$drivers/lib" "$lib"
      fi
    done
  '';

  passthru = {
    inherit libdrm version;
    inherit (libglvnd) driverLink;

    # Use stub libraries from libglvnd and headers from Mesa.
    stubs = stdenv.mkDerivation {
      name = "libGL-${libglvnd.version}";
      outputs = [ "out" "dev" ];

      # On macOS, libglvnd is not supported, so we just use what mesa
      # build. We need to also include OpenGL.framework, and some
      # extra tricks to go along with. We add mesa’s libGLX to support
      # the X extensions to OpenGL.
      buildCommand = if stdenv.hostPlatform.isDarwin then ''
        mkdir -p $out/nix-support $dev
        echo ${OpenGL} >> $out/nix-support/propagated-build-inputs
        ln -s ${self.out}/lib $out/lib

        mkdir -p $dev/lib/pkgconfig $dev/nix-support
        echo "$out" > $dev/nix-support/propagated-build-inputs
        ln -s ${self.dev}/include $dev/include

        cat <<EOF >$dev/lib/pkgconfig/gl.pc
      Name: gl
      Description: gl library
      Version: ${self.version}
      Libs: -L${self.out}/lib -lGL
      Cflags: -I${self.dev}/include
      EOF

        cat <<EOF >$dev/lib/pkgconfig/glesv1_cm.pc
      Name: glesv1_cm
      Description: glesv1_cm library
      Version: ${self.version}
      Libs: -L${self.out}/lib -lGLESv1_CM
      Cflags: -I${self.dev}/include
      EOF

        cat <<EOF >$dev/lib/pkgconfig/glesv2.pc
      Name: glesv2
      Description: glesv2 library
      Version: ${self.version}
      Libs: -L${self.out}/lib -lGLESv2
      Cflags: -I${self.dev}/include
      EOF
      ''

      # Otherwise, setup gl stubs to use libglvnd.
      else ''
        mkdir -p $out/nix-support
        ln -s ${libglvnd.out}/lib $out/lib

        mkdir -p $dev/{,lib/pkgconfig,nix-support}
        echo "$out" > $dev/nix-support/propagated-build-inputs
        ln -s ${self.dev}/include $dev/include

        genPkgConfig() {
          local name="$1"
          local lib="$2"

          cat <<EOF >$dev/lib/pkgconfig/$name.pc
        Name: $name
        Description: $lib library
        Version: ${self.version}
        Libs: -L${libglvnd.out}/lib -l$lib
        Cflags: -I${self.dev}/include
        EOF
        }

        genPkgConfig gl GL
        genPkgConfig egl EGL
        genPkgConfig glesv1_cm GLESv1_CM
        genPkgConfig glesv2 GLESv2
      '';
    };
  };

  meta = with stdenv.lib; {
    description = "An open source implementation of OpenGL";
    homepage = https://www.mesa3d.org/;
    license = licenses.mit; # X11 variant, in most files
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ vcunat ];
  };
};
in self
