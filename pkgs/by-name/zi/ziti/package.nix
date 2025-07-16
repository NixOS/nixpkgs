{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ziti";
  version = "1.6.12";

  src = fetchFromGitHub {
    owner = "openziti";
    repo = "ziti";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z4VJonL+nfjIZCFt3+6pY73u9qcRCp89TQPQlzHXu1k=";
  };

  vendorHash = "sha256-6FJbF7MUPnVP9YMM7mEkRdo6tF6vZrorM7EdmAmFc40=";

  subPackages = [
    "ziti"
    "controller"
    "router"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openziti/ziti/common/version.Version=v${finalAttrs.version}"
    "-X github.com/openziti/ziti/common/version.Revision=v${finalAttrs.src.rev}"
    "-X github.com/openziti/ziti/common/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "CLI for working with a Ziti deployment";
    changelog = "https://github.com/openziti/ziti/releases/tag/v${finalAttrs.version}";
    homepage = "https://openziti.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jamalhabash
      andrewzah
    ];
    mainProgram = "ziti";
  };
})
