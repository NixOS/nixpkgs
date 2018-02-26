{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "bibtexparser";
  version = "1.0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc41cdd8332c2bf44b97daf1f135f4f267c3b744c33976655cd270b66f964c0a";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Bibtex parser for python 2.7 and 3.3 and newer";
    homepage = https://github.com/sciunto-org/python-bibtexparser;
    license = with lib.licenses; [ gpl3 bsd3 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
