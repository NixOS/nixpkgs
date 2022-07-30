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
, cmdliner_1_1
, alcotest
}:

buildDunePackage rec {
  pname = "ca-certs-nss";
  version = "3.80";

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs-nss/releases/download/v${version}/ca-certs-nss-${version}.tbz";
    sha256 = "1hdjsfk1hky43l0bxahj81l5dg8bzqdz1fw5n0jsmgm4dj09qqk5";
  };

  useDune2 = true;

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
    cmdliner_1_1
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
