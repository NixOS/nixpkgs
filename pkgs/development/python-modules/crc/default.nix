{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "crc";
  version = "7.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Nicoretti";
    repo = "crc";
    rev = "refs/tags/${version}";
    hash = "sha256-y30tnGG+G9dWBO8MUFYm2IGHiGIPbv4kB2VwhV0/C74=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "crc" ];

  disabledTestPaths = [ "test/bench" ];

  meta = with lib; {
    description = "Python module for calculating and verifying predefined & custom CRC's";
    homepage = "https://nicoretti.github.io/crc/";
    changelog = "https://github.com/Nicoretti/crc/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jleightcap ];
    mainProgram = "crc";
  };
}
