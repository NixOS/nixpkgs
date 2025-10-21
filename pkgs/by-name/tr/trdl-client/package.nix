{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "trdl-client";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "trdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wu4PRFJDT6SvWPHOaOmBBVX1wvkDrjigxah5ZCq8NsY=";
  };

  sourceRoot = "${finalAttrs.src.name}/client";

  vendorHash = "sha256-veSgWyk1ytHRNHuuZJBV+1rqGDsdEb01CImm+EexFCk=";

  subPackages = [ "cmd/trdl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/werf/trdl/client/pkg/trdl.Version=${finalAttrs.src.rev}"
  ];

  tags = [
    "dfrunmount"
    "dfssh"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/trdl";
  versionCheckProgramArg = "version";

  meta = {
    description = "Universal solution for delivering your software updates";
    longDescription = ''
      trdl is an Open Source solution providing a secure channel for delivering
      updates from the Git repository to the end user.

      The project team releases new versions of the software and switches them
      in the release channels. Git acts as the single source of truth while
      Vault is used as a tool to verify operations as well as populate and
      maintain the TUF repository.

      The user selects a release channel, continuously receives the latest
      software version from the TUF repository, and uses it.
    '';
    homepage = "https://trdl.dev";
    changelog = "https://github.com/werf/trdl/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.azahi ];
    mainProgram = "trdl";
  };
})
