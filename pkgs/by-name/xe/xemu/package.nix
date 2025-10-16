{
  lib,
  SDL2,
  SDL2_image,
  fetchFromGitHub,
  gettext,
  git,
  glib,
  gtk3,
  cmake,
  curl,
  libdrm,
  libepoxy,
  libpcap,
  libsamplerate,
  libslirp,
  libgbm,
  vulkan-headers,
  vulkan-loader,
  meson,
  ninja,
  openssl,
  perl,
  pkg-config,
  python3Packages,
  stdenv,
  vte,
  which,
  wrapGAppsHook3,
  cacert,
  darwin,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xemu";
  version = "0.8.107";

  src = fetchFromGitHub {
    owner = "xemu-project";
    repo = "xemu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rrf3PVetkrHbogOd+1ZrtfHdRJPrq0c9q4Zg0LSOy94=";

    nativeBuildInputs = [
      git
      meson
    ];
    # also fetch required git submodules
    postFetch = ''
      cd "$out"
      export NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

      meson subprojects download \
        SPIRV-Reflect VulkanMemoryAllocator berkeley-softfloat-3 berkeley-testfloat-3 genconfig glslang imgui \
        implot json keycodemapdb nv2a_vsh_cpu tomlplusplus volk xxhash || true
      find subprojects -type d -name .git -prune -execdir rm -r {} +
    '';
  };
  __structuredAttrs = true;
  nativeBuildInputs = [
    SDL2
    meson
    cmake
    ninja
    perl
    pkg-config
    which
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
    desktopToDarwinBundle
  ]
  ++ (with python3Packages; [
    python
    pyyaml
    distlib
  ]);

  buildInputs = [
    SDL2
    SDL2_image
    gettext
    glib
    gtk3
    curl
    libepoxy
    libpcap
    libsamplerate
    libslirp
    openssl
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libdrm
    libgbm
    vte
  ];

  configureFlags = [
    "--disable-strip"
    "--target-list=i386-softmmu"
    "--disable-werror"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # As seen in the official build script ($src/build.sh)
    "--disable-cocoa"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "--enable-hvf"
  ];

  buildFlags = [ "qemu-system-i386" ];

  separateDebugInfo = true;

  dontUseMesonConfigure = true;
  dontUseCmakeConfigure = true;

  setOutputFlags = false;

  strictDeps = true;

  postPatch = ''
    patchShebangs scripts

    substituteInPlace ./scripts/xemu-version.sh \
      --replace-fail 'date -u' "date -d @$SOURCE_DATE_EPOCH '+%Y-%m-%d %H:%M:%S'"
  '';

  preConfigure = ''
    configureFlagsArray+=("--extra-cflags=-DXBOX=1 -Wno-error=redundant-decls")
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    configureFlagsArray+=("-Wno-implicit-function-declaration")
  ''
  + ''
    # When the data below can't be obtained through git, the build process tries
    # to run `XEMU_COMMIT=$(cat XEMU_COMMIT)` (and similar)
    echo '${finalAttrs.version}' > XEMU_VERSION
  '';

  preBuild = ''
    cd build
    substituteInPlace ./build.ninja --replace /usr/bin/env $(which env)
  '';

  postBuild =
    lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
      # Needed for HVF acceleration
      codesign --entitlements $src/accel/hvf/entitlements.plist -f -s - qemu-system-i386-unsigned
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mv qemu-system-i386-unsigned qemu-system-i386
    '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -T qemu-system-i386 $out/bin/xemu

    for resolution in 16x16 24x24 32x32 48x48 128x128 256x256 512x512
    do
      install -Dm644 -T ../ui/icons/xemu_$resolution.png \
        $out/share/icons/hicolor/$resolution/apps/xemu.png
    done

    install -Dm644 -T ../ui/xemu.desktop $out/share/applications/xemu.desktop

    runHook postInstall
  '';

  meta = {
    homepage = "https://xemu.app/";
    description = "Original Xbox emulator";
    longDescription = ''
      A free and open-source application that emulates the original Microsoft
      Xbox game console, enabling people to play their original Xbox games on
      Windows, macOS, and Linux systems.
    '';
    changelog = "https://github.com/xemu-project/xemu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xemu";
    maintainers = with lib.maintainers; [
      marcin-serwin
      matteopacini
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
