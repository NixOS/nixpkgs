{ stdenv, lib, fetchurl, fetchpatch
, pkgconfig, intltool, ninja, meson
, file, flex, bison, expat, libdrm, xorg, wayland, wayland-protocols, openssl
, llvmPackages, libffi, libomxil-bellagio, libva-minimal
, libelf, libvdpau, python3Packages
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
    ++ lib.optionals stdenv.hostPlatform.isx86 [ "svga" ]
    ++ lib.optionals (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) [ "vc4" ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "freedreno" "etnaviv" "imx" ]
  );
  defaultDriDrivers = optionals (elem "drm" eglPlatforms) ([ ]
    ++ lib.optionals pciePlatform [ "r200" ]
    ++ lib.optionals (pciePlatform || stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) [ "nouveau" ]
    ++ lib.optionals stdenv.hostPlatform.isx86 [ "i915" "i965" ]);
  defaultVulkanDrivers = optionals stdenv.hostPlatform.isLinux ([ ]
    ++ lib.optional stdenv.hostPlatform.isx86 "intel"
    ++ lib.optional enableRadv "amd");
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
      else dri_);
  vulkanDrivers =
    if vulkan_ == null
    then defaultVulkanDrivers
    else vulkan_;
in

let
  version = "19.1.1";
  branch  = head (splitString "." version);
in

let self = stdenv.mkDerivation rec {
  pname = "mesa";
  inherit version;

  src =  fetchurl {
    urls = [
      "ftp://ftp.freedesktop.org/pub/mesa/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/older-versions/${branch}.x/${version}/mesa-${version}.tar.xz"
      "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz"
    ];
    sha256 = "10amy5sdmpjbskr3xazgk0jyli8xpgi0y1nsmjr76hx8nhb4n4bj";
  };

  prePatch = "patchShebangs .";

  # TODO:
  #  revive ./dricore-gallium.patch when it gets ported (from Ubuntu), as it saved
  #  ~35 MB in $drivers; watch https://launchpad.net/ubuntu/+source/mesa/+changelog
  patches = [
    ./missing-includes.patch # dev_t needs sys/stat.h, time_t needs time.h, etc.-- fixes build w/musl
    ./opencl-install-dir.patch
    ./disk_cache-include-dri-driver-path-in-cache-key.patch
  ] # do not prefix user provided dri-drivers-path
    ++ lib.optional (lib.versionOlder version "19.0.0") (fetchpatch {
      url = "https://gitlab.freedesktop.org/mesa/mesa/commit/f6556ec7d126b31da37c08d7cb657250505e01a0.patch";
      sha256 = "0z6phi8hbrbb32kkp1js7ggzviq7faz1ria36wi4jbc4in2392d9";
    })
    ++ lib.optionals (lib.versionOlder version "19.1.0") [
      # do not prefix user provided d3d-drivers-path
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/mesa/mesa/commit/dcc48664197c7e44684ccfb970a4ae083974d145.patch";
        sha256 = "1nhs0xpx3hiy8zfb5gx1zd7j7xha6h0hr7yingm93130a5902lkb";
      })

      # don't build libGLES*.so with GLVND
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/mesa/mesa/commit/b01524fff05eef66e8cd24f1c5aacefed4209f03.patch";
        sha256 = "1pszr6acx2xw469zq89n156p3bf3xf84qpbjw5fr1sj642lbyh7c";
      })
    ];

  outputs = [ "out" "dev" "drivers" ]
            ++ lib.optional (elem "swrast" galliumDrivers) "osmesa";

  # TODO: Figure out how to enable opencl without having a runtime dependency on clang
  mesonFlags = [
    "--sysconfdir=/etc"

    # Don't build in debug mode
    # https://gitlab.freedesktop.org/mesa/mesa/blob/master/docs/meson.html#L327
    "-Db_ndebug=true"

    "-Ddisk-cache-key=${placeholder "drivers"}"
    "-Ddri-search-path=${libglvnd.driverLink}/lib/dri"

    "-Dplatforms=${concatStringsSep "," eglPlatforms}"
    "-Ddri-drivers=${concatStringsSep "," driDrivers}"
    "-Dgallium-drivers=${concatStringsSep "," galliumDrivers}"
    "-Dvulkan-drivers=${concatStringsSep "," vulkanDrivers}"

    "-Ddri-drivers-path=${placeholder "drivers"}/lib/dri"
    "-Dvdpau-libs-path=${placeholder "drivers"}/lib/vdpau"
    "-Dxvmc-libs-path=${placeholder "drivers"}/lib"
    "-Domx-libs-path=${placeholder "drivers"}/lib/bellagio"
    "-Dva-libs-path=${placeholder "drivers"}/lib/dri"
    "-Dd3d-drivers-path=${placeholder "drivers"}/lib/d3d"

    "-Dgallium-vdpau=true"
    "-Dgallium-xvmc=true"
    "-Dgallium-opencl=disabled"
    "-Dshared-glapi=true"
    "-Dgles1=true"
    "-Dgles2=true"
    "-Dglx=dri"
    "-Dglvnd=true"
    "-Dllvm=true"
    "-Dshared-llvm=true"
    "-Dglx-direct=true"
  ] ++ optional (elem "swrast" galliumDrivers) "-Dosmesa=gallium" # used by wine
    ++ optionals (stdenv.isLinux) [
      "-Ddri3=true"
      "-Dgallium-omx=bellagio"
      "-Dgallium-va=true"
      "-Dgallium-xa=true" # used in vmware driver
      "-Dgallium-nine=true" # Direct3D in Wine
      "-Dgbm=true"
      "-Degl=true"
    ];

  buildInputs = with xorg; [
    expat llvmPackages.llvm libglvnd xorgproto
    libX11 libXext libxcb libXt libXfixes libxshmfence libXrandr
    libffi libvdpau libelf libXvMC
    libpthreadstubs openssl /*or another sha1 provider*/
  ] ++ lib.optionals (elem "wayland" eglPlatforms) [ wayland wayland-protocols ]
    ++ lib.optionals stdenv.isLinux [ libomxil-bellagio libva-minimal ]
    ++ lib.optional withValgrind valgrind-light;

  nativeBuildInputs = [
    pkgconfig meson ninja
    intltool bison flex file
    python3Packages.python python3Packages.Mako
  ];

  propagatedBuildInputs = with xorg; [
    libXdamage libXxf86vm
  ] ++ optional stdenv.isLinux libdrm
    ++ optionals stdenv.isDarwin [ OpenGL Xplugin ];

  enableParallelBuilding = true;
  doCheck = false;

  postInstall = ''
    # Some installs don't have any drivers so this directory is never created.
    mkdir -p $drivers
  '' + optionalString (galliumDrivers != []) ''
    mkdir -p $drivers/lib

    # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM
    mv -t $drivers/lib       \
      $out/lib/libxatracker* \
      $out/lib/libvulkan_*

    # Move other drivers to a separate output
    mv $out/lib/lib*_mesa* $drivers/lib

    # move libOSMesa to $osmesa, as it's relatively big
    mkdir -p $osmesa/lib
    mv -t $osmesa/lib/ $out/lib/libOSMesa*

    # move vendor files
    mv $out/share/ $drivers/

    # Update search path used by glvnd
    for js in $drivers/share/glvnd/egl_vendor.d/*.json; do
      substituteInPlace "$js" --replace '"libEGL_' '"'"$drivers/lib/libEGL_"
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
    # set the default search path for DRI drivers; used e.g. by X server
    substituteInPlace "$dev/lib/pkgconfig/dri.pc" --replace "$drivers" "${libglvnd.driverLink}"

    # remove pkgconfig files for GL/EGL; they are provided by libGL.
    rm $dev/lib/pkgconfig/{gl,egl}.pc

    # Update search path used by pkg-config
    for pc in $dev/lib/pkgconfig/{d3d,dri,xatracker}.pc; do
      substituteInPlace "$pc" --replace $out $drivers
    done

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
