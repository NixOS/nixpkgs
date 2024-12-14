{
  lib,
  buildDunePackage,
  fetchurl,
  digestif,
  mirage-clock,
  x509,
  logs,
  fmt,
  bos,
  cmdliner,
  alcotest,
}:

buildDunePackage rec {
  pname = "ca-certs-nss";
  version = "3.107";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs-nss/releases/download/v${version}/ca-certs-nss-${version}.tbz";
    hash = "sha256-VIT5cIa+MWpQlTLtywPp6Qx5jgCyNEyHRQcQWvXw/GA=";
  };

  propagatedBuildInputs = [
    mirage-clock
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
