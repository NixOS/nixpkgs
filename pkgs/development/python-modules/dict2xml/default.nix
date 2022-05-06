{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dict2xml";
  version = "1.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZgCqMx8X7uODNhH3GJmkOnZhLKdVoVdpzyBJLEsaoBY=";
  };

  pythonImportsCheck = [
    "dict2xml"
  ];

  meta = with lib; {
    description = "Library to convert a Python dictionary into an XML string";
    homepage = "https://github.com/delfick/python-dict2xml";
    license = licenses.mit;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
