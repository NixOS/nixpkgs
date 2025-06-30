{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  packaging,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rmscene";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ricklupton";
    repo = "rmscene";
    tag = "v${version}";
    hash = "sha256-LaUzWEptzCGir6ZOgyMfP3Uf+jERT+cTb7Wx/eean1I=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [ "packaging" ];

  dependencies = [ packaging ];

  pythonImportsCheck = [ "rmscene" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/ricklupton/rmscene/blob/${src.tag}/README.md#changelog";
    description = "Read v6 .rm files from the reMarkable tablet";
    homepage = "https://github.com/ricklupton/rmscene";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
