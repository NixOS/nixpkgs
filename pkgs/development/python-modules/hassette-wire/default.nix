{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "hassette-wire";
  version = "0.64.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NodeJSmith";
    repo = "hassette";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EbodQdt9yZZ7HTlnxFbw/Aa+SZ7f6322CSKEKOmyqxQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/wire";

  build-system = [ uv-build ];

  dependencies = [ pydantic ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hassette_wire" ];

  meta = {
    description = "Wire types shared between hassette and its client";
    homepage = "https://github.com/NodeJSmith/hassette";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
