{
  lib,
  buildDunePackage,
  fetchurl,
  bos,
  fpath,
  ptime,
  mirage-crypto,
  x509,
  astring,
  logs,
  cacert,
  alcotest,
  fmt,
}:

buildDunePackage rec {
  pname = "ca-certs";
  version = "1.0.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs/releases/download/v${version}/ca-certs-${version}.tbz";
    hash = "sha256-0818j1SLrs7yCNQlh3qBHYmOx9HZxL3qb3hlLHyDYcw=";
  };

  propagatedBuildInputs = [
    bos
    fpath
    ptime
    mirage-crypto
    x509
    astring
    logs
  ];

  doCheck = true;
  checkInputs = [
    cacert # for /etc/ssl/certs/ca-bundle.crt
    alcotest
    fmt
  ];

  meta = with lib; {
    description = "Detect root CA certificates from the operating system";
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
    homepage = "https://github.com/mirage/ca-certs";
  };
}
