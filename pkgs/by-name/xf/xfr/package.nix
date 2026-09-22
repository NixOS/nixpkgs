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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "lance0";
    repo = "xfr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WjW4Uup9/JEckUOdMQFdqhYoEeRPOYhD0DT+NCSt+sY=";
  };

  cargoHash = "sha256-Bpq6RY2d4Vm9pQdp+6rcMgtPIvveKirGTMm7UI3Ivas=";

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
