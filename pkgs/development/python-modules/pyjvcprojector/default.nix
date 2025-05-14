{
  aiodns,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyjvcprojector";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SteveEasley";
    repo = "pyjvcprojector";
    tag = "v${version}";
    hash = "sha256-ow9pCigbQpxLibIq1hsRifXuzJfbWnqpWmnkM5lC3I4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiodns
  ];

  pythonImportsCheck = [ "jvcprojector" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/SteveEasley/pyjvcprojector/releases/tag/${src.tag}";
    description = "Python library for controlling a JVC Projector over a network connection";
    homepage = "https://github.com/SteveEasley/pyjvcprojector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
