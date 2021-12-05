{ lib, buildPythonPackage, pythonOlder, fetchFromGitHub, setuptools, websockets
}:

buildPythonPackage rec {
  pname = "graphql-subscription-manager";
  version = "0.4.3";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyGraphqlWebsocketManager";
    rev = version;
    sha256 = "sha256-+LP+MDeHo0svoN/o0in6xtIqrfxs+UCBQRtBe4lZt+4=";
  };

  propagatedBuildInputs = [ setuptools websockets ];

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
