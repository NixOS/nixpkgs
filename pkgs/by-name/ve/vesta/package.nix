{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "vesta";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "kvesta";
    repo = "vesta";
    tag = "v${version}";
    hash = "sha256-/AIzIXtevFRW7gxA3dgNC8SPpT5ABrulf62GOpsw5Wc=";
  };

  vendorHash = "sha256-Rs1UXvSP3iXQySW5yVkP5JTWmEOej4atTpYpmQccbro=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "version" ];

  checkFlags = [ "-skip=TestPythonMatch" ];

  meta = {
    description = "Static analysis of vulnerabilities, Docker and Kubernetes cluster configuration";
    homepage = "https://github.com/kvesta/vesta";
    changelog = "https://github.com/kvesta/vesta/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vesta";
  };
}
