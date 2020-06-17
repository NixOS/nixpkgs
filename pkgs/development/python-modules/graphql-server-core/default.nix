{ buildPythonPackage
, fetchFromGitHub
, lib

, black
, graphql-core
, promise
}:

buildPythonPackage rec {
  pname = "graphql-server-core";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "123q3xziv0s22h10v3f5slirf4b6nxj0hnmarwx9vws6x21bgrgh";
  };

  propagatedBuildInputs = [
    graphql-core
    promise
  ];

  checkPhase = "black --check graphql_server tests";

  checkInputs = [
    black
  ];

  meta = with lib; {
    description = "Core package for using GraphQL in a custom server easily";
    homepage = "https://github.com/graphql-python/graphql-server-core";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
