{
  buildPythonPackage,
  fetchFromGitea,
  lib,
  nix-update-script,
  poetry-core,
  pytestCheckHook,
  pure-sasl,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pydle";
  version = "1.1.0";
  pyproject = true;
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "shiz";
    repo = "pydle";
    tag = "v${version}";
    hash = "sha256-LxlE0JVKgwDcPB7QuKkmfBWG33pDzG0F9qaL88xF8r4=";
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
