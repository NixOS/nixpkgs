{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tint";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "ashish0kumar";
    repo = "tint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y2Jb/YF7rpEAmDVI5wEB+Sy7Ap2XxNrKQfnAogVdYSY=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ashish0kumar/tint/releases/tag/v${finalAttrs.version}";
    description = "Command-line tool to recolor images using theme palettes";
    homepage = "https://github.com/ashish0kumar/tint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashish0kumar ];
    mainProgram = "tint";
    platforms = lib.platforms.unix;
  };
})
