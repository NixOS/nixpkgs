{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tlsanalyzer";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "csnp";
    repo = "tls-analyzer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qswwS4ZNWyda38zI+1+WYOk4XVuXIO76E2+NfcvUy7s=";
  };

  vendorHash = "sha256-CPdAinTb3Yd7dPvDiTHrKk/xeJnO0aAYETWMkf34yWI=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  subPackages = [ "cmd/tlsanalyzer/" ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "TLS/SSL security analyzer for quantum readiness assessment and CNSA 2.0 compliance";
    homepage = "https://github.com/csnp/tls-analyzer";
    changelog = "https://github.com/csnp/tls-analyzer/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tlsanalyzer";
  };
})
