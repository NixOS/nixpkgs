{ lib, buildDunePackage, fetchurl
, bos, fpath, rresult, ptime, mirage-crypto, x509, astring, logs
}:

buildDunePackage rec {
  pname = "ca-certs";
  version = "0.1.3";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ca-certs/releases/download/v${version}/ca-certs-v${version}.tbz";
    sha256 = "0jpghxjp2n8wx6ig0d2x87ycaql6mb92w8ai3xh3jb288m7g02zn";
  };

  useDune2 = true;

  propagatedBuildInputs = [ bos fpath rresult ptime mirage-crypto x509 astring logs ];

  # tests need access to network and systemwide ca cert chain
  doCheck = false;

  meta = with lib; {
    description = "Detect root CA certificates from the operating system";
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
    homepage = "https://github.com/mirage/ca-certs";
  };
}
