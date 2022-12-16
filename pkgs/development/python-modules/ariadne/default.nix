{ buildPythonPackage
, fetchFromGitHub
, freezegun
, graphql-core
, lib
, opentracing
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, snapshottest
, starlette
, typing-extensions
, werkzeug
}:

buildPythonPackage rec {
  pname = "ariadne";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "mirumee";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-HiIg+80vaMzQdqF2JKzP7oZzfpqSTrumXmUHGLT/wF8=";
  };

  propagatedBuildInputs = [ graphql-core starlette typing-extensions ];

  checkInputs = [
    freezegun
    opentracing
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    snapshottest
    werkzeug
  ];

  meta = with lib; {
    description = "Python library for implementing GraphQL servers using schema-first approach";
    homepage = "https://ariadnegraphql.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
