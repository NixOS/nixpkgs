{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "bibtexparser";
  version = "0.6.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5888219ac5db1c63ae0ad4db52ec7ad87fe7a32bd60e62ee87bceedb8ebf73b8";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Bibtex parser for python 2.7 and 3.3 and newer";
    homepage = https://github.com/sciunto-org/python-bibtexparser;
    license = with lib.licenses; [ gpl3 bsd3 ];
    maintainer = with lib.maintainers; [ fridh ];
  };
}
