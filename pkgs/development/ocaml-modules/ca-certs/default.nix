{ lib, buildDunePackage, fetchurl
, bos, fpath, ptime, mirage-crypto, x509, astring, logs
, cacert, alcotest, fmt
}:

buildDunePackage rec {
  pname = "ca-certs";
  version = "0.2.2";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs/releases/download/v${version}/ca-certs-v${version}.tbz";
    sha256 = "sha256-Tx53zBJemZh3ODh/8izahxDoJvXvNFLyAA8LMM1mhlI=";
  };

  useDune2 = true;

  propagatedBuildInputs = [ bos fpath ptime mirage-crypto x509 astring logs ];

  # Assumes nss-cacert < 3.74 https://github.com/mirage/ca-certs/issues/21
  doCheck = false;
  checkInputs = [
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
