{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "filecheck";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AntonLydike";
    repo = "filecheck";
    tag = "v${version}";
    hash = "sha256-Ml8RUk2zgDuU8rZbedjSv3mk6TdIxCBVECA6kMcig5o=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "filecheck" ];

  meta = {
    changelog = "https://github.com/antonlydike/filecheck/releases/tag/${src.tag}";
    homepage = "https://github.com/antonlydike/filecheck";
    license = lib.licenses.asl20;
    description = "Python-native clone of LLVMs FileCheck tool";
    mainProgram = "filecheck";
    maintainers = with lib.maintainers; [ yorickvp ];
  };
}
