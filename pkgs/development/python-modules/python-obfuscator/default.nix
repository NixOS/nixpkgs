{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  regex,
  typer,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-obfuscator";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "davidteather";
    repo = "python-obfuscator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ddFmlNBtITMPJszLjD2FNjSFF8TrawOv0q7iB3EIdAY=";
  };

  pythonRelaxDeps = [ "typer" ];

  build-system = [ poetry-core ];

  dependencies = [
    regex
    typer
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "python_obfuscator" ];

  meta = {
    description = "Module to obfuscate code";
    homepage = "https://github.com/davidteather/python-obfuscator";
    changelog = "https://github.com/davidteather/python-obfuscator/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
