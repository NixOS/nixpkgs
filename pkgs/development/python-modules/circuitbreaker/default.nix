{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "circuitbreaker";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabfuel";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-l0ASt9CQmgJmWpRrghElbff/gaNOmxNh+Wj0C0p4jE0=";
  };

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "circuitbreaker"
  ];

  meta = with lib; {
    description = "Python Circuit Breaker implementation";
    homepage = "https://github.com/fabfuel/circuitbreaker";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
