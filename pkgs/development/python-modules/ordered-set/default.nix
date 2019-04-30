{ buildPythonPackage, fetchPypi, lib, pytest }:

buildPythonPackage rec {
  pname = "ordered-set";
  version = "3.1";

  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0slg1ys58dzxl96mws3sydzavdzqdk0s2nrc852dphd9kbm07dzr";
  };

  checkPhase = ''
    py.test test.py
  '';

  meta = {
    description = "A MutableSet that remembers its order, so that every entry has an index.";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
