{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, packaging
, pytestCheckHook
, tomli
}:

buildPythonPackage rec {
  pname = "pyproject-metadata";
  version = "0.5.0";
  format = "pyproject";

  src = fetchPypi rec {
    inherit pname version;
    hash = "sha256-6YN9I3V8XJ//+19/N8+be8LZc30OlZt/XV8YmVFulww=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    packaging
  ];

  checkInputs = [
    pytestCheckHook
    tomli
  ];

  # Many broken tests, and missing test files
  doCheck = false;

  meta = with lib; {
    description = "PEP 621 metadata parsing";
    homepage = "https://github.com/FFY00/python-pyproject-metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ fridh ];
  };
}
