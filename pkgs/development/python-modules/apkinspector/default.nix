{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "apkinspector";
  version = "1.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erev0s";
    repo = "apkInspector";
    tag = "v${version}";
    hash = "sha256-6efXoiyjTEzadZ5aut4lFbjth03Uyw8REIYQYjvWS/c=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "apkInspector" ];

  meta = {
    description = "Module designed to provide detailed insights into the zip structure of APK files";
    homepage = "https://github.com/erev0s/apkInspector";
    changelog = "https://github.com/erev0s/apkInspector/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "apkInspector";
  };
}
