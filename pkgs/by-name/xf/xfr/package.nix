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
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "lance0";
    repo = "xfr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v761IbFwe0pLhv3M2WTOEfw/MPlk69sZC0HP5DNzFFM=";
  };

  cargoHash = "sha256-ByzQMWTrs92KGd2qCX4DvVJSBTL/GwZAcFJTERWGuW0=";

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  doInstallCheck = true;

  # opt ouf of default features to deselect the update-check feature
  buildNoDefaultFeatures = true;

  buildFeatures = [
    "discovery"
  ];

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
