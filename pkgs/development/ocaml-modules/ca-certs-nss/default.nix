{
  lib,
  buildDunePackage,
  fetchurl,
  digestif,
  mirage-ptime,
  x509,
  logs,
  fmt,
  bos,
  cmdliner,
  alcotest,
}:

buildDunePackage rec {
  pname = "ca-certs-nss";
  version = "3.108-1";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs-nss/releases/download/v${version}/ca-certs-nss-${version}.tbz";
    hash = "sha256-soYi8sW1OrfznijCGYgFWY6gayguQs3/FcBXlC2FflY=";
  };

  propagatedBuildInputs = [
    mirage-ptime
    x509
    digestif
  ];

  buildInputs = [
    logs
    fmt
    bos
    cmdliner
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = with lib; {
    description = "X.509 trust anchors extracted from Mozilla's NSS";
    homepage = "https://github.com/mirage/ca-certs-nss";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    mainProgram = "extract-from-certdata";
  };
}
