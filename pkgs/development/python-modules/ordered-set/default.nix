{ buildPythonPackage, fetchPypi, lib, pytest }:

buildPythonPackage rec {
  pname = "ordered-set";
  version = "3.1.1";

  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "094pww79pawgmjgwi47r0fji9irb7sr4xc9xwjbb0wwcficaigx7";
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
