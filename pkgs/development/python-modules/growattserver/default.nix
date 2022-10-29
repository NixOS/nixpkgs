{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "growattserver";
  version = "1.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "indykoning";
    repo = "PyPi_GrowattServer";
    rev = "refs/tags/${version}";
    hash = "sha256-79/siHqwY3TNFIxodR24TJwsrKapG1GP4u4fIKxdFI4=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "growattServer"
  ];

  meta = with lib; {
    description = "Python package to retrieve information from Growatt units";
    homepage = "https://github.com/indykoning/PyPi_GrowattServer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
