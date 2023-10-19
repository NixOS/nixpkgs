{ lib
, buildDunePackage
, fetchurl
, mirage-crypto
, mirage-clock
, x509
, logs
, fmt
, bos
, astring
, cmdliner
, alcotest
}:

buildDunePackage rec {
  pname = "ca-certs-nss";
  version = "3.92";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs-nss/releases/download/v${version}/ca-certs-nss-${version}.tbz";
    hash = "sha256-F6eF5jQO9qJACQldad8va5jXPj05o61L8Bp1SDXHBTg=";
  };

  propagatedBuildInputs = [
    mirage-crypto
    mirage-clock
    x509
  ];

  buildInputs = [
    logs
    fmt
    bos
    astring
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
