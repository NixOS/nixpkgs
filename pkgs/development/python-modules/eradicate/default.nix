{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "eradicate";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "eradicate";
    tag = version;
    hash = "sha256-V3g9qYM/TiOz83IMoUwu0CvFWBxB5Yk3Dy3G/Dz3vYw=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "eradicate" ];

  enabledTestPaths = [ "test_eradicate.py" ];

  meta = with lib; {
    description = "Library to remove commented-out code from Python files";
    mainProgram = "eradicate";
    homepage = "https://github.com/myint/eradicate";
    changelog = "https://github.com/wemake-services/eradicate/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mmlb ];
  };
}
