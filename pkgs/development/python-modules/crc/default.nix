{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "crc";
  version = "6.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Nicoretti";
    repo = "crc";
    rev = "refs/tags/${version}";
    hash = "sha256-GlXDDG8NZ3Lp0IwYKS0+fZG85uVdo4V8mZnCa+za02U=";
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
    mainProgram = "crc";
    homepage = "https://nicoretti.github.io/crc/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jleightcap ];
  };
}
