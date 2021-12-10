{ lib
, buildPythonPackage
, fetchFromGitHub
, graphql-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "graphql-relay";
  version = "3.1.0";

  src = fetchFromGitHub {
     owner = "graphql-python";
     repo = "graphql-relay-py";
     rev = "v3.1.0";
     sha256 = "06ybi4bwqdffa5kn8xnns06wh3l0zj3qlzrxk1wpxqq320hyzx9x";
  };

  propagatedBuildInputs = [
    graphql-core
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "graphql_relay" ];

  meta = with lib; {
    description = "A library to help construct a graphql-py server supporting react-relay";
    homepage = "https://github.com/graphql-python/graphql-relay-py/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
