{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tldx";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "brandonyoungdev";
    repo = "tldx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SN5uGIzC6a+cPSnrfL+1A+3NIQR6gbILFv7X9L8g/N8=";
  };

  vendorHash = "sha256-IVxhgsw36/fNVV0Kn7aBza3htPzK09l84qBg3FBtOo0=";

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
