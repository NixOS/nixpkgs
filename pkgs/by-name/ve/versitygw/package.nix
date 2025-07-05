{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "versitygw";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${version}";
    hash = "sha256-gRVUR1BlGVLS6+OZUvOVgoRNDiHrDSDu2L3iBwZ/zbg=";
  };

  vendorHash = "sha256-7efskc/3bj8/8D5LgQnkC4TYib+73fpDyRKDDcFVRvA=";

  doCheck = false; # Require access to online S3 services

  ldFlags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Versity S3 gateway, a high-performance S3 translation service";
    homepage = "https://github.com/versity/versitygw";
    changelog = "https://github.com/versity/versitygw/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "versitygw";
  };
}
