{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "railroad-diagrams";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wRClrA4I/DWNw/hL5rowQMn0R61c6qiNg9Ho6nXqi+4=";
  };

  # this is a dependency of pyparsing, which is a dependency of pytest
  doCheck = false;

  pythonImportsCheck = [ "railroad" ];

  meta = with lib; {
    description = "Generate SVG railroad syntax diagrams, like on JSON.org";
    homepage = "https://github.com/tabatkins/railroad-diagrams";
    license = licenses.cc0;
    maintainers = with maintainers; [ jonringer ];
  };
}
