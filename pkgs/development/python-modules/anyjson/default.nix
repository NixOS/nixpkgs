{ lib, buildPythonPackage, fetchPypi, isPy3k, nose }:

buildPythonPackage rec {
  pname = "anyjson";
  version = "0.3.3";

  # The tests are written in a python2 syntax but anyjson is python3 valid
  doCheck = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "37812d863c9ad3e35c0734c42e0bf0320ce8c3bed82cd20ad54cb34d158157ba";
  };

  buildInputs = [ nose ];

  meta = with lib; {
    homepage = https://bitbucket.org/runeh/anyjson/;
    description = "Wrapper that selects the best available JSON implementation";
    license = licenses.bsd2;
  };
}
