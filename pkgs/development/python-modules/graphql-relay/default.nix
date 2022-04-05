{ lib
, buildPythonPackage
, fetchPypi
, graphql-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "graphql-relay";
  version = "3.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-En9AkT8Ry4R0Uu95STEmGq47Ii6q+Xb3yEMCmFNOVNM=";
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
