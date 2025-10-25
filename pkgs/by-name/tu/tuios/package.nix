{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tuios";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "Gaurav-Gosain";
    repo = "tuios";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uP/IOWI+ESsfZsGrmpZOvVmalPWy+B/wS6s/xgQiJyg=";
  };

  vendorHash = "sha256-h3MRdo03okkPBDdB8/RCVaKhOGdGQP3tPkXI6V6Hn2g=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.builtBy=nixpkgs"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI OS (Terminal Multiplexer";
    homepage = "https://github.com/Gaurav-Gosain/tuios";
    changelog = "https://github.com/Gaurav-Gosain/tuios/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "tuios";
  };
})
