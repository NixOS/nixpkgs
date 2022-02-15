{ lib
, buildPythonPackage
, fetchFromGitHub
, ifaddr
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosenseme";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ShK4DP1lAtAFI6z2kf5T1ecbNTKUn2kqUjps2ABRegg=";
  };

  propagatedBuildInputs = [
    ifaddr
  ];

  pythonImportsCheck = [
    "aiosenseme"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Module to interact with SenseME fans and lights by Big Ass Fans";
    homepage = "https://github.com/bdraco/aiosenseme";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
