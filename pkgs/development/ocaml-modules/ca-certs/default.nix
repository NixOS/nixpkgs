{ lib, buildDunePackage, fetchurl
, bos, fpath, rresult, ptime, mirage-crypto, x509, astring, logs
, cacert, alcotest
}:

buildDunePackage rec {
  pname = "ca-certs";
  version = "0.2.1";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs/releases/download/v${version}/ca-certs-v${version}.tbz";
    sha256 = "d43109496a5129feff967d557c556af96f8b10456896a405c43b7cf0c35d0af3";
  };

  useDune2 = true;

  propagatedBuildInputs = [ bos fpath rresult ptime mirage-crypto x509 astring logs ];

  # Assumes nss-cacert < 3.74 https://github.com/mirage/ca-certs/issues/21
  doCheck = false;
  checkInputs = [
    cacert    # for /etc/ssl/certs/ca-bundle.crt
    alcotest
  ];

  meta = with lib; {
    description = "Detect root CA certificates from the operating system";
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
    homepage = "https://github.com/mirage/ca-certs";
  };
}
