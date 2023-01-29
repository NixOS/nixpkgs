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
  version = "3.86";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs-nss/releases/download/v${version}/ca-certs-nss-${version}.tbz";
    hash = "sha256-3b20vYBP9T2uR17Vxyilfs/9C72WVUrgR7T582V++lQ=";
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
  nativeCheckInputs = [ alcotest ];

  meta = with lib; {
    description = "X.509 trust anchors extracted from Mozilla's NSS";
    homepage = "https://github.com/mirage/ca-certs-nss";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    mainProgram = "extract-from-certdata";
  };
}
