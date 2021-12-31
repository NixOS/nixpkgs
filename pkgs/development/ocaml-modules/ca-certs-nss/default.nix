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
  version = "3.71.0.1";

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs-nss/releases/download/v${version}/ca-certs-nss-v${version}.tbz";
    sha256 = "b83749d983781631745079dccb7345d9ee1b52c1844ce865e97a25349289a124";
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
