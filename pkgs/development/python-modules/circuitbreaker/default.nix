{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "circuitbreaker";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabfuel";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-jaDCMGCZZu3STluYeHDNgdEPf2DNq7bXJ0LPV3JZdk0=";
  };

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "circuitbreaker"
  ];

  meta = with lib; {
    description = "Python Circuit Breaker implementation";
    homepage = "https://github.com/fabfuel/circuitbreaker";
    changelog = "https://github.com/fabfuel/circuitbreaker/releases/tag/${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
