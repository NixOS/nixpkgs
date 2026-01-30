{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  logurich,
  pydantic,
  pytest-cov-stub,
  pytestCheckHook,
  pyvis,
  rich,
  typing-extensions,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyvest";
  version = "5.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PakitoSec";
    repo = "cyvest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OvAnhasc4iZtfi8olQ4rLaokcaC/b5rYdPPMn2pVYTA=";
  };

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ uv-build ];

  dependencies = [
    click
    logurich
    pydantic
    rich
    typing-extensions
  ];

  optional-dependencies = {
    visualization = [
      pyvis
    ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cyvest" ];

  meta = {
    description = "Cybersecurity Investigation Model";
    homepage = "https://github.com/PakitoSec/cyvest";
    changelog = "https://github.com/PakitoSec/cyvest/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
