{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "apkinspector";
  version = "1.3.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "erev0s";
    repo = "apkInspector";
    tag = "v${version}";
    hash = "sha256-haJD5fioXd6KX7x2gNezGj2yUEMi/CFQUkCqa0t5yjA=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "apkInspector" ];

  meta = with lib; {
    description = "Module designed to provide detailed insights into the zip structure of APK files";
    homepage = "https://github.com/erev0s/apkInspector";
    changelog = "https://github.com/erev0s/apkInspector/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "apkInspector";
  };
}
