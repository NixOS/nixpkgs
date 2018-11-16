{ buildPythonPackage, fetchPypi, lib, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "ordered-set";
  version = "3.0.2";

  buildInputs = [ pytest pytestrunner ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d292b866fa44f339ac6e624e3d338accfb415ce0a8431595d51990fbdf61d3b";
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
