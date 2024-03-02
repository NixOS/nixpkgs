{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "growattserver";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "indykoning";
    repo = "PyPi_GrowattServer";
    rev = "refs/tags/${version}";
    hash = "sha256-ATxXjIF5QRsdLuXZCOWMwvbBzawrhlYZ+wodITz36sE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    changelog = "https://github.com/indykoning/PyPi_GrowattServer/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
