{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiocoap,
  dtlssocket,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytradfri";
  version = "15.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    tag = version;
    hash = "sha256-CibNk0cpIGRlIg9O8yLpyTEct1vBHixma/Ty6iA4/Rg=";
  };

  build-system = [ setuptools ];

  dependencies = [ pydantic ];

  optional-dependencies = {
    async = [
      aiocoap
      dtlssocket
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ optional-dependencies.async;

  pythonImportsCheck = [ "pytradfri" ];

  meta = {
    description = "Python package to communicate with the IKEA Trådfri ZigBee Gateway";
    homepage = "https://github.com/home-assistant-libs/pytradfri";
    changelog = "https://github.com/home-assistant-libs/pytradfri/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
