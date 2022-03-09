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
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-71Z+5nVvg+aozJAKmBGJg5Gqq1OIVH7Xv33Q82IHhXg=";
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
