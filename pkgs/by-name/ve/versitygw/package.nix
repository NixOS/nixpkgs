{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "versitygw";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${version}";
    hash = "sha256-wKD06yyXxV41Lbr2scvTR+fhd4uy6EIlArAVoNxMbzU=";
  };

  vendorHash = "sha256-rgZJn3WvsoV4QfLpceAxVWuBncQGdH5oKnR12FqhyCE=";

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
