{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "flatten-dict";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ianlini";
    repo = "flatten-dict";
    tag = finalAttrs.version;
    hash = "sha256-wzCuTnLOOeybhBPcyyPNPKWoJBHwaKkmARTzlg87wtU=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flatten_dict" ];

  meta = {
    description = "Module for flattening and unflattening dict-like objects";
    homepage = "https://github.com/ianlini/flatten-dict";
    changelog = "https://github.com/ianlini/flatten-dict/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
