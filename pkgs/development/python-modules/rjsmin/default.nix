{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rjsmin";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jBvNghFD/s8jJCAStV4TYQhAqDnNRns1jxY1kBDWLa4=";
  };

  # The package does not ship tests, and the setup machinary confuses
  # tests auto-discovery
  doCheck = false;

  pythonImportsCheck = [
    "rjsmin"
  ];

  meta = with lib; {
    description = "Module to minify Javascript";
    homepage = "http://opensource.perlig.de/rjsmin/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
