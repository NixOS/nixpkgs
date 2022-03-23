{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "graphql-subscription-manager";
  version = "0.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyGraphqlWebsocketManager";
    rev = version;
    hash = "sha256-7MqFsttMNnWmmWKj1zaOORBTDGt6Wm8GU7w56DfPl2c=";
  };

  propagatedBuildInputs = [
    setuptools
    websockets
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "graphql_subscription_manager"
  ];

  meta = with lib; {
    description = "Python3 library for graphql subscription manager";
    homepage = "https://github.com/Danielhiversen/PyGraphqlWebsocketManager";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
