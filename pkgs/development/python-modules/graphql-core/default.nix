{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-benchmark
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-LLvfjlio0UmTwR2ZRpsoKTJoWHOEk740QE6K+5GNlrk=";
  };

  checkInputs = [
    pytest-asyncio
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "graphql"
  ];

  meta = with lib; {
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
