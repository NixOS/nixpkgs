{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysyncobj";
  version = "0.3.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bakwc";
    repo = "PySyncObj";
    rev = "refs/tags/${version}";
    hash = "sha256-ZWzvvv13g/iypm+MIl5q0Y8ekqzZEY5upSTPk3MFTPI=";
  };

  # Tests require network features
  doCheck = false;

  pythonImportsCheck = [
    "pysyncobj"
  ];

  meta = with lib; {
    description = "Python library for replicating your class";
    homepage = "https://github.com/bakwc/PySyncObj";
    changelog = "https://github.com/bakwc/PySyncObj/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
