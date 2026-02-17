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
  version = "5.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PakitoSec";
    repo = "cyvest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fYFYIcjbO9dyOFiuKU077T/88fo6A6nIr04kZgL8ta0=";
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
    changelog = "https://github.com/PakitoSec/cyvest/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
