{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  argh,
  rich,
  rich-argparse,
  pytestCheckHook,
  hypothesis,
  pytest-asyncio,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "brei";
  version = "0.2.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "entangled";
    repo = "brei";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6AwveNt+HUc/lRjKhdoxGLee8AqzIUePHfEK46nLuJY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    argh
    rich
    rich-argparse
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pytest-asyncio
    pytest-timeout
  ];

  pythonRelaxDeps = [
    "argh"
    "rich"
  ];

  pythonImportsCheck = [
    "brei"
  ];

  meta = {
    description = "Minimal build system";
    homepage = "https://github.com/entangled/brei";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mjm ];
  };
})
