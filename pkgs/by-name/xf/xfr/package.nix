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
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "lance0";
    repo = "xfr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m41hICpbx8aZprKrjdAdvoDEzCi8gLoLia6TTi/AThY=";
  };

  cargoHash = "sha256-uUKAjq8jj/NPpi5DHktNGBLWvecSPUwYdMQF/4o7JnM=";

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
