{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-metadata
, pyyaml
, python
}:

buildPythonPackage rec {
  pname = "markdown";
  version = "3.3.7";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    pname = "Markdown";
    inherit version;
    sha256 = "cbb516f16218e643d8e0a95b309f77eb118cb138d39a4f27851e6a63581db874";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  checkInputs = [ pyyaml ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [ "markdown" ];

  meta = with lib; {
    description = "A Python implementation of John Gruber's Markdown with Extension support";
    homepage = "https://github.com/Python-Markdown/markdown";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
