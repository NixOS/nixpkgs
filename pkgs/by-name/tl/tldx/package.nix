{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tldx";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "brandonyoungdev";
    repo = "tldx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yKC/omwFG4equAlBHz25Wx+X/06N0x4vdNchiWSfZZQ=";
  };

  vendorHash = "sha256-FVcTTfOf1eAiR6Iys1uesZWpVrnMTGX7zS1MdeXDoQM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/brandonyoungdev/tldx/cmd.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    license = lib.licenses.asl20;
    mainProgram = "tldx";
    description = "Domain availability research tool";
    homepage = "https://github.com/brandonyoungdev/tldx";
    changelog = "https://github.com/brandonyoungdev/tldx/blob/main/CHANGELOG.md";
    maintainers = with lib.maintainers; [ sylonin ];
  };
})
