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
  version = "0.8.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b02facfbc9b0f1867739949a223f3d3267ed8663691cc95abd94e2c1d8c2b46";
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
