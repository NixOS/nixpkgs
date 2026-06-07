{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "circuitbreaker";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabfuel";
    repo = "circuitbreaker";
    tag = version;
    hash = "sha256-7BpYGhha0PTYzsE9CsN4KxfJW/wm2i6V+uAeamBREBQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pythonImportsCheck = [ "circuitbreaker" ];

  meta = {
    description = "Python Circuit Breaker implementation";
    homepage = "https://github.com/fabfuel/circuitbreaker";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
