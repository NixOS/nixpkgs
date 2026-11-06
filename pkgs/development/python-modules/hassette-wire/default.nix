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
  version = "0.63.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NodeJSmith";
    repo = "hassette";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DO2Q9exyHaacd7InwDWKNk48qdvlFGUotDgD8peiDGY=";
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
