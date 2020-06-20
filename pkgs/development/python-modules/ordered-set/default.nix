{ buildPythonPackage, fetchPypi, lib, isPy27, pytest }:

buildPythonPackage rec {
  pname = "ordered-set";
  version = "4.0.1";
  disabled = isPy27;

  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "a31008c57f9c9776b12eb8841b1f61d1e4d70dfbbe8875ccfa2403c54af3d51b";
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
