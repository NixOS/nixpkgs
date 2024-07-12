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
  version = "1.2.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "erev0s";
    repo = "apkInspector";
    rev = "refs/tags/v${version}";
    hash = "sha256-WVqaRWOLo8/Xav+AtaxE3EKR9lZe+Z+ep/K88FGbASg=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "apkInspector" ];

  meta = with lib; {
    description = "Module designed to provide detailed insights into the zip structure of APK files";
    homepage = "https://github.com/erev0s/apkInspector";
    changelog = "https://github.com/erev0s/apkInspector/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "apkInspector";
  };
}
