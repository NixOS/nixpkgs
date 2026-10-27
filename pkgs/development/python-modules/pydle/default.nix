{
  buildPythonPackage,
  fetchFromCodeberg,
  lib,
  nix-update-script,
  poetry-core,
  pytestCheckHook,
  pure-sasl,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pydle";
  version = "1.2.0";
  pyproject = true;
  src = fetchFromCodeberg {
    owner = "shiz";
    repo = "pydle";
    tag = "v${version}";
    hash = "sha256-460oY68PSmmgXq4bLOr8SB9RiMy3wc5EwEV7s5AKePY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pure-sasl
  ];

  pythonImportsCheck = [
    "pydle"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IRCv3-compliant Python 3 IRC library";
    homepage = "https://codeberg.org/shiz/pydle";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ polyfloyd ];
  };
}
