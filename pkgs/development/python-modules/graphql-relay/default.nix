{ lib
, buildPythonPackage
, fetchPypi

, pythonOlder

# build
, poetry-core

# runtime
, graphql-core
, typing-extensions

# tests
, pytest-asyncio
, pytest-describe
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "graphql-relay";
  version = "3.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H/HFEpg1bkgaC+AJzN/ySYMs5T8wVZwTOPIqDg0XJQw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    graphql-core
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytest-asyncio
    pytest-describe
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
