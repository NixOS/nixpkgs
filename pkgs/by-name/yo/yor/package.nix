{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "yor";
  version = "0.1.200";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = "yor";
    rev = finalAttrs.version;
    hash = "sha256-IoQe1/D3Sl1y76dXH0CuwU6/LBC6n6or9vsysHhDeeg=";
  };

  vendorHash = "sha256-uT/jGD4hDVes4h+mlSIT2p+C9TjxnUWsmKv9haPjjLc=";

  doCheck = false;

  # https://github.com/bridgecrewio/yor/blob/main/set-version.sh
  preBuild = ''
    cat << EOF > src/common/version.go
    package common

    const Version = "${finalAttrs.version}"
    EOF
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Extensible auto-tagger for your IaC files. The ultimate way to link entities in the cloud back to the codified resource which created it";
    homepage = "https://github.com/bridgecrewio/yor";
    changelog = "https://github.com/bridgecrewio/yor/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
})
