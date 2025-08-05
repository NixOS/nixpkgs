{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  mandown,
  installShellFiles,
  pkg-config,
  curl,
  openssl,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij";
  version = "0.42.2";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O7BZlPSBWy+q349NYCUsw4Rb5X3xyl5Ar+a/uQPQhZY=";
  };

  # Remove the `vendored_curl` feature in order to link against the libcurl from nixpkgs instead of
  # the vendored one
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail ', "vendored_curl"' ""
  '';

  cargoHash = "sha256-Vo3bshaHjy2F2WFGgaIDEFFAh0e5VPp2G4fETgIH484=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    mandown
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
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # Ensure that we don't vendor curl, but instead link against the libcurl from nixpkgs
  installCheckPhase = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    runHook preInstallCheck

    ldd "$out/bin/zellij" | grep libcurl.so

    runHook postInstallCheck
  '';

  postInstall = ''
    mandown docs/MANPAGE.md > zellij.1
    installManPage zellij.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd $pname \
      --bash <($out/bin/zellij setup --generate-completion bash) \
      --fish <($out/bin/zellij setup --generate-completion fish) \
      --zsh <($out/bin/zellij setup --generate-completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    changelog = "https://github.com/zellij-org/zellij/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      therealansh
      _0x4A6F
      abbe
      pyrox0
      matthiasbeyer
      ryan4yin
    ];
    mainProgram = "zellij";
  };
})
