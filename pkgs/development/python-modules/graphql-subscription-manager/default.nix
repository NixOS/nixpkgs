{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "graphql-subscription-manager";
  version = "0.5.1";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyGraphqlWebsocketManager";
    rev = version;
    sha256 = "sha256-PVQa6JmBnToXuL/wNkYO0b+K1e9yrQgRUzWNUbFN5mM=";
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
