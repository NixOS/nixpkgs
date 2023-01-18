{ lib, buildDunePackage, fetchurl
, bos, fpath, ptime, mirage-crypto, x509, astring, logs
, cacert, alcotest, fmt
}:

buildDunePackage rec {
  pname = "ca-certs";
  version = "0.2.3";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs/releases/download/v${version}/ca-certs-${version}.tbz";
    hash = "sha256-0tjWRX2RXvbXg974Lzvl7C9W+S4gIU9Y7dY8nC/GDpw=";
  };

  duneVersion = "3";

  propagatedBuildInputs = [ bos fpath ptime mirage-crypto x509 astring logs ];

  doCheck = true;
  nativeCheckInputs = [
    cacert    # for /etc/ssl/certs/ca-bundle.crt
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
