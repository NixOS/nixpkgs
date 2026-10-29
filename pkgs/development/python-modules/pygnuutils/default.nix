{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygnuutils";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matan1008";
    repo = "pygnuutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RySqq1V6ad3W53Rp/ZweMPnbM7C3RDm3b6KV/FKQyW0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
  ];

  pythonImportsCheck = [ "pygnuutils" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/matan1008/pygnuutils/releases/tag/${finalAttrs.src.tag}";
    description = "Pure python implementation for GNU utils";
    homepage = "https://github.com/matan1008/pygnuutils";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
