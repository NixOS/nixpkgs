{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "circuitbreaker";
  version = "2.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabfuel";
    repo = "circuitbreaker";
    tag = version;
    hash = "sha256-7BpYGhha0PTYzsE9CsN4KxfJW/wm2i6V+uAeamBREBQ=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pythonImportsCheck = [ "circuitbreaker" ];

  meta = with lib; {
    description = "Python Circuit Breaker implementation";
    homepage = "https://github.com/fabfuel/circuitbreaker";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
