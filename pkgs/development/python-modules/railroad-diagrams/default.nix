{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "railroad-diagrams";
  version = "2.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wRClrA4I/DWNw/hL5rowQMn0R61c6qiNg9Ho6nXqi+4=";
  };

  # This is a dependency of pyparsing, which is a dependency of pytest
  doCheck = false;

  pythonImportsCheck = [
    "railroad"
  ];

  meta = with lib; {
    description = "Module to generate SVG railroad syntax diagrams";
    homepage = "https://github.com/tabatkins/railroad-diagrams";
    license = licenses.cc0;
    maintainers = with maintainers; [ jonringer ];
  };
}
