{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "versitygw";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mjtW5Jyx5hDGAony3ZPK8u4QgDdXbP+RCCTglUc7AR0=";
  };

  vendorHash = "sha256-3M2LOWEszQlfSvnIBN/mQ966qizOtUwa68ugTSvvw8U=";

  doCheck = false; # Require access to online S3 services

  ldFlags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Versity S3 gateway, a high-performance S3 translation service";
    homepage = "https://github.com/versity/versitygw";
    changelog = "https://github.com/versity/versitygw/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "versitygw";
  };
})
