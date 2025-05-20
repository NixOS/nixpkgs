{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "versitygw";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${version}";
    hash = "sha256-BsosWFzaN7P/QXPf86t+fJ6PkBGuykUCTmFEGCgclOE=";
  };

  vendorHash = "sha256-yDHuNqrCfrvKz4spofdw9EH7J9JZvpCYejlz893nwBk=";

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
