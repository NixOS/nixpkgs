{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fontconfig,
  installShellFiles,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  pkg-config,
  curl,
  libssh2,
  openssl,
  sqlite,
  wayland,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
  withWebServer ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-unwrapped";
  version = "0.46.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JpSNWC6jHahirUmnWRZKiVRonFjjIZx9j0V//6t1+iM=";
  };

  # Remove the `vendored_curl` feature in order to link against the libcurl from nixpkgs instead of
  # the vendored one
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail ', "vendored_curl"' ""
  ''
  + lib.optionalString (!withWebServer) ''
    substituteInPlace Cargo.toml \
      --replace-fail ', "web_server_capability"' ""
  '';

  cargoHash = "sha256-i3Vh7w9YeGUkGIsbqA2UIiLtMqsSC+/ehdSDIfTckM8=";

  env.LIBSSH2_SYS_USE_PKG_CONFIG = 1;
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    (lib.getDev curl)
  ];

  buildInputs = [
    curl
    libssh2
    openssl
    sqlite
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  # Ensure that we don't vendor curl, but instead link against the libcurl from nixpkgs
  installCheckPhase = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    runHook preInstallCheck

    ldd "$out/bin/zellij" | grep libcurl.so

    runHook postInstallCheck
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 assets/dev.zellij.Zellij.desktop -t $out/share/applications
      install -Dm644 assets/dev.zellij.Zellij.metainfo.xml -t $out/share/metainfo

      for size in 128 256 512 1024; do
        install -Dm644 zellij-utils/assets/icons/logo$size.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/dev.zellij.Zellij.png
      done
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd zellij \
        --bash <($out/bin/zellij setup --generate-completion bash) \
        --fish <($out/bin/zellij setup --generate-completion fish) \
        --zsh <($out/bin/zellij setup --generate-completion zsh)
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    # winit/glutin and system font discovery load these libraries with dlopen.
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        fontconfig
        libGL
        libx11
        libxcursor
        libxi
        libxkbcommon
        wayland
      ]
    } $out/bin/zellij
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    changelog = "https://github.com/zellij-org/zellij/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      therealansh
      _0x4A6F
      abbe
      matthiasbeyer
      ryan4yin
    ];
    mainProgram = "zellij";
  };
})
