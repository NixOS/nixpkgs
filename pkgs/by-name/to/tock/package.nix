{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tock";
  version = "2.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kriuchkov";
    repo = "tock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RGgBsuB169NbFj+neqyX/OJU872V4X65+wE+B73lfj4=";
  };

  vendorHash = "sha256-D7753Yu4NGE4AdTyDtLCM+nCZJHj9Eb5aP1STehARQo=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/kriuchkov/tock/internal/app/commands.version=${finalAttrs.version}"
    "-X=github.com/kriuchkov/tock/internal/app/commands.commit=${finalAttrs.src.rev}"
    "-X=github.com/kriuchkov/tock/internal/app/commands.date=1970-01-01T00:00:00Z"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Time tracking tool for the command line";
    homepage = "https://github.com/kriuchkov/tock";
    changelog = "https://github.com/kriuchkov/tock/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ricardomaps ];
    mainProgram = "tock";
  };
})
