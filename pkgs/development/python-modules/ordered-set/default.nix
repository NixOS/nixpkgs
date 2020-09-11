{ buildPythonPackage, fetchPypi, lib, isPy27, pytest }:

buildPythonPackage rec {
  pname = "ordered-set";
  version = "4.0.2";
  disabled = isPy27;

  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "159syfbqnwqnivzjfn3x7ak3xwrxmnzbji7c2qhj1jjv0pgv54xs";
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
