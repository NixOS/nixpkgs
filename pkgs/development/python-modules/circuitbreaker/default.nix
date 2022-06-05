{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "circuitbreaker";
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabfuel";
    repo = pname;
    rev = version;
    sha256 = "sha256-3hFa8dwCso5tj26ek2jMdVBRzu5H3vkdjQlDYw2hSH0=";
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
