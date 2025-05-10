{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dncil";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "dncil";
    tag = "v${version}";
    hash = "sha256-bndkiXkIYTd071J+mgkmJmA+9J5yJ+9/oDfAypN7wYo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dncil" ];

  meta = {
    description = "Module to disassemble Common Intermediate Language (CIL) instructions";
    homepage = "https://github.com/mandiant/dncil";
    changelog = "https://github.com/mandiant/dncil/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
