{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "crc";
  version = "5.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Nicoretti";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+C4cUKXZCpAXil8X4gTK3AhqNVWDrBQYY2Kgkd3+gqc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "crc"
  ];

  disabledTestPaths = [
    "test/bench"
  ];

  meta = with lib; {
    changelog = "https://github.com/Nicoretti/crc/releases/tag/${version}";
    description = "Python module for calculating and verifying predefined & custom CRC's";
    homepage = "https://nicoretti.github.io/crc/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jleightcap ];
  };
}
