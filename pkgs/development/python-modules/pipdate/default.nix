{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, appdirs
, importlib-metadata
, packaging
, requests
, rich
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pipdate";
  version = "0.5.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G2t+wsVGj7cDbsnWss7XqKU421WqygPzAZkhbTu9Jks=";
  };

  nativeBuildInputs = [
    wheel
  ];

  propagatedBuildInputs = [
    appdirs
    requests
    rich
    setuptools
    packaging
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # Tests require network access and pythonImportsCheck requires configuration file
  doCheck = false;

  pythonImportsCheck = [
    "pipdate"
  ];

  meta = with lib; {
    description = "pip update helpers";
    homepage = "https://github.com/nschloe/pipdate";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ costrouc ];
  };
}
