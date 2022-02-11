{ lib
, black
, boto3
, buildPythonPackage
, fetchFromGitHub
, isort
, jinja2
, md-toc
, mdformat
, poetry-core
, pyparsing
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mypy-boto3-builder";
  version = "6.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vemel";
    repo = "mypy_boto3_builder";
    rev = version;
    sha256 = "1krsh8pmxigpzz21gvsy7qnpnwfkyyjbz92bqp9iflf7kklfhb79";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    black
    boto3
    isort
    jinja2
    md-toc
    mdformat
    pyparsing
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Should be fixed with 5.x
    "test_get_types"
  ];

  pythonImportsCheck = [ "mypy_boto3_builder" ];

  meta = with lib; {
    description = "Type annotations builder for boto3";
    homepage = "https://vemel.github.io/mypy_boto3_builder/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
