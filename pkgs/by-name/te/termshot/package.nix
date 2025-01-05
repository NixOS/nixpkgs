{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "termshot";
    tag = "v${version}";
    hash = "sha256-x2XVA686E3GPMz1hzTWZ1FqVflfPWTwbAf8JAG8HMp0=";
  };

  vendorHash = "sha256-ON3dmwf9IYEf+e4Z5EJ72wC4IIr/0/ssgzAJmRb7MSk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/homeport/termshot/internal/cmd.version=${version}"
  ];

  checkFlags = [ "-skip=^TestPtexec$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Creates screenshots based on terminal command output";
    homepage = "https://github.com/homeport/termshot";
    changelog = "https://github.com/homeport/termshot/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "termshot";
  };
}
