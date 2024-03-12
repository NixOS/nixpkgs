{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sacn";
  version = "1.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LimA0I8y1tdjFk244iWvKJj0Rx3OEaYOSIJtirRHh4o=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "sacn"
  ];

  meta = with lib; {
    description = "A simple ANSI E1.31 (aka sACN) module";
    homepage = "https://github.com/Hundemeier/sacn";
    changelog = "https://github.com/Hundemeier/sacn/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
