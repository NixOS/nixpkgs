{ buildPythonPackage
, fetchFromGitHub
, lib
, black
, graphql-core
, promise
, fetchpatch
, pythonOlder
}:

buildPythonPackage rec {
  pname = "graphql-server-core";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "1w3biv2za2m1brwjy0z049c2m94gm1zfwxzgc6lwrsci724jv9fr";
  };

  disable = pythonOlder "3.6";

  patches = [
    (fetchpatch {
      url = "https://github.com/graphql-python/graphql-server-core/commit/865ee9d5602f352c958f6f7e15adbe9abe216784.patch";
      sha256 = "03p44p4j8rys7mgamh2h9ibbnac2cqwvp5f5hrl2avj2hh0l6j46";
    })
  ];

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
