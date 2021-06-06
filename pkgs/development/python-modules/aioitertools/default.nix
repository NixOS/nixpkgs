{ lib

, buildPythonPackage
, fetchPypi
, pythonOlder
, typing-extensions
, coverage
, python
, toml
}:

buildPythonPackage rec {
  pname = "aioitertools";
  version = "0.7.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18ql6k2j1839jf2rmmmm29v6fb7mr59l75z8nlf0sadmydy6r9al";
  };

  propagatedBuildInputs = [ typing-extensions ];
  checkInputs = [ coverage toml ];

  checkPhase = ''
    ${python.interpreter} -m coverage run -m aioitertools.tests
  '';

  meta = with lib; {
    description = "Implementation of itertools, builtins, and more for AsyncIO and mixed-type iterables.";
    license = licenses.mit;
    homepage = "https://pypi.org/project/aioitertools/";
    maintainers = with maintainers; [ teh ];
  };
}
