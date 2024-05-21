{ lib
, buildPythonPackage
, fetchPypi
, html5lib
, pythonOlder
, rdflib
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "pyrdfa3";
  version = "3.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "pyRdfa3";
    hash = "sha256-c2gdq5V/YJAWlnZziLlWpXaccwvEUdpv+y8ONvGDFMI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    rdflib
    html5lib
    requests
  ];

  pythonImportsCheck = [
    "pyRdfa"
  ];

  meta = with lib; {
    description = "RDFa 1.1 distiller/parser library";
    homepage = "https://github.com/prrvchr/pyrdfa3/";
    changelog = "https://github.com/prrvchr/pyrdfa3/releases/tag/v${version}";
    license = licenses.w3c;
    maintainers = with maintainers; [ ambroisie ];
  };
}
