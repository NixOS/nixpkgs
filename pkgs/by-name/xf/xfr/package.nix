{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xfr";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "lance0";
    repo = "xfr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8vZ/29B7bdiWd+ckwMUPUMWHYtrgoIlzw3wM6khtrZo=";
  };

  cargoHash = "sha256-Vkh1Rb1/MKN+8Rc00iVfrK4x3AcmyKVQ8FMQX2JhZX4=";

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = ''
    installShellCompletion --cmd xfr \
      --bash <($out/bin/xfr --completions bash) \
      --fish <($out/bin/xfr --completions fish) \
      --zsh <($out/bin/xfr --completions zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  __structuredAttrs = true;

  meta = {
    description = "Modern iperf3 alternative with a live TUI, multi-client server, and QUIC support.";
    mainProgram = "xfr";
    homepage = "https://github.com/lance0/xfr";
    changelog = "https://github.com/lance0/xfr/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      _0x4A6F
      herbetom
    ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.linux;
  };
})
