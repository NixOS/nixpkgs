{ lib
, requests
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aladdin-connect";
  version = "0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "shoejosh";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kLvMpSGa5WyDOH3ejAJyFGsB9IiMXp+nvVxM/ZkxyFw=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aladdin_connect"
  ];

  meta = with lib; {
    description = "Python library for interacting with Genie Aladdin Connect devices";
    homepage = "https://github.com/shoejosh/aladdin-connect";
    changelog = "https://github.com/shoejosh/aladdin-connect/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
