{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ziti";
  version = "2.0.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "openziti";
    repo = "ziti";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Aq/DpL9yYzdG270MzASbXJPzQ7AYEv91qGKAhEqOJk8=";
  };

  vendorHash = "sha256-oL53p692Txkc2xS2iARcjZRMig2GGtcsLrMt5msW/qw=";

  subPackages = [
    "ziti"
    "controller"
    "router"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openziti/ziti/v2/common/version.Version=${finalAttrs.version}"
    "-X github.com/openziti/ziti/v2/common/version.Revision=v${finalAttrs.src.rev}"
    "-X github.com/openziti/ziti/v2/common/version.BuildDate=1970-01-01T00:00:00Z"
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
