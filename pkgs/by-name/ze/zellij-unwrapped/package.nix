{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  curl,
  openssl,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
  withWebServer ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-unwrapped";
  version = "0.45.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pp++8CTIM4PuAYOjM7GnzU4TXTaw8XuDMow5k/7KQgY=";
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

  cargoHash = "sha256-rCK7FyAUIjUq6dxEw9YBaGm29xYvlYjX0b1xHU03XVU=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    (lib.getDev curl)
  ];

  buildInputs = [
    curl
    openssl
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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zellij \
      --bash <($out/bin/zellij setup --generate-completion bash) \
      --fish <($out/bin/zellij setup --generate-completion fish) \
      --zsh <($out/bin/zellij setup --generate-completion zsh)
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
