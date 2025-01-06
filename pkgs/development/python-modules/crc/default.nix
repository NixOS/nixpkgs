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
  version = "7.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Nicoretti";
    repo = "crc";
    tag = version;
    hash = "sha256-Oa2VSzNT+8O/rWZurIr7RnP8m3xAEVOQLs+ObT4xIa0=";
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
