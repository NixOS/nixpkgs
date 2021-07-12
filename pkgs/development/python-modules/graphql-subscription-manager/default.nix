{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "graphql-subscription-manager";
  version = "0.4.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyGraphqlWebsocketManager";
    rev = version;
    sha256 = "1176xzr9fa7gl5cm0pcv5lb45d2ms5awi601rjcr3a0a14a1i8fz";
  };

  propagatedBuildInputs = [
    setuptools
    websockets
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "graphql_subscription_manager" ];

  meta = with lib; {
    description = "Python3 library for graphql subscription manager";
    homepage = "https://github.com/Danielhiversen/PyGraphqlWebsocketManager";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
