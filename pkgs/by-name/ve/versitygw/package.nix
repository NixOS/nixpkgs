{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "versitygw";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    rev = "refs/tags/v${version}";
    hash = "sha256-giPk0037zMqrqG6L1b9M7Us9d9YpGNjlJXWaNCIx3vc=";
  };

  vendorHash = "sha256-vW1LQDr2u/owt919HyRkd6frCQquCq5rrYFAp0n3x2o=";

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
