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
  version = "3.66";

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs-nss/releases/download/v${version}/ca-certs-nss-v${version}.tbz";
    sha256 = "f0f8035b470f2a48360b92d0e6287f41f98e4ba71576a1cd4c9246c468932f09";
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
