{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "versitygw";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${version}";
    hash = "sha256-/64SiVZUXGRI3guvSIqDBXOmbxucPCZEceCObTee6jI=";
  };

  vendorHash = "sha256-HzPjHNZdQ+IJl91QviVG6zydhTb/1tOZGdFBpHLUTfE=";

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
