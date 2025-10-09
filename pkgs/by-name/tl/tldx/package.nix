{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tldx";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "brandonyoungdev";
    repo = "tldx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JdVngzH6Md7LPV5m8p+C8CW/JRdXlEX19C9+oMTEtDY=";
  };

  vendorHash = "sha256-Dzeo4ZvbKUow8IF5Lal1GK7sT71IEBPDitYCvNaK4aI=";

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
