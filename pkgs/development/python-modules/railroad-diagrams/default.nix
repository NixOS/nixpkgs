{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "railroad-diagrams";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a1ec227666be2000e76794aa740f77987f1586077aae4d090d2633b3064c976";
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
