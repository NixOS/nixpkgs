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
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SteveEasley";
    repo = "pyjvcprojector";
    tag = "v${version}";
    hash = "sha256-GKtBAW7opa6EQ+O3XfAi7D0V2KLWf+c+ECpBLbgVA9w=";
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
