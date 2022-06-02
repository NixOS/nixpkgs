{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "graphql-subscription-manager";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyGraphqlWebsocketManager";
    rev = "refs/tags/${version}";
    hash = "sha256-5+KHPm/JuazObvuC2ip6hwQxvjJH/lDgukJMH49cuwg=";
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
