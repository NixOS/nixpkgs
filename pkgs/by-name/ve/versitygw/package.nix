{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "versitygw";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    rev = "refs/tags/v${version}";
    hash = "sha256-hrGPHl8vfLsL1JMcaU+RAQj6CaBJKsW+Q2AGCbgYUSA=";
  };

  vendorHash = "sha256-zZufxxZZ5Lfr0vWcygXdiRK+bhUr/+MFk4ajJGz5TMI=";

  doCheck = false; # Require access to online S3 services

  ldFlags = [
    "-s"
    "-w"
  ];

  nativeInputChecks = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Versity s3 gateway, a high-performance S3 translation service";
    homepage = "https://github.com/versity/versitygw";
    changelog = "https://github.com/versity/versitygw/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "versitygw";
  };
}
