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
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "lance0";
    repo = "xfr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DvPeX9uzD9Cg1xUWSR+maKR9GPZH57DBH6mYXCjNKr8=";
  };

  cargoHash = "sha256-u19Yc+fusqme4PycIAGvYbKMRfKLRIf9L/Iysutiejc=";

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

  meta = {
    description = "Modern iperf3 alternative with a live TUI, multi-client server, and QUIC support.";
    mainProgram = "xfr";
    homepage = "https://github.com/lance0/xfs";
    changelog = "https://github.com/lance0/xfr/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ herbetom ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.linux;
  };
})
