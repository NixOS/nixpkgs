{ lib
, buildDunePackage
, fetchurl
, rresult
, mirage-crypto
, mirage-clock
, x509
, logs
, fmt
, hex
, bos
, astring
, cmdliner
, alcotest
}:

buildDunePackage rec {
  pname = "ca-certs-nss";
  version = "3.64.0.1";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs-nss/releases/download/v${version}/ca-certs-nss-v${version}.tbz";
    sha256 = "909c64076491647471f785527bfdd9a886a34504edabf88542b43f27b86067f9";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    rresult
    mirage-crypto
    mirage-clock
    x509
  ];

  buildInputs = [
    logs
    fmt
    hex
    bos
    astring
    cmdliner
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = with lib; {
    license = licenses.isc;
    description = "X.509 trust anchors extracted from Mozilla's NSS";
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/ca-certs-nss";
  };
}
