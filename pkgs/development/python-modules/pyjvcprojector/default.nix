{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyjvcprojector";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SteveEasley";
    repo = "pyjvcprojector";
    tag = "v${version}";
    hash = "sha256-c8xhpcr8HmTDTzoGn9vwsvNl2O+EamRbG9Nf6lgqw7c=";
  };

  build-system = [ setuptools ];

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
