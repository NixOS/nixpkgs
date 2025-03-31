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
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabfuel";
    repo = pname;
    tag = version;
    hash = "sha256-lwLy/bWvXhmQbRJ6Qii7e0SrEL3iDPGs6k7Bqamvg50=";
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
