{ lib
, black
, boto3
, buildPythonPackage
, fetchFromGitHub
, isort
, jinja2
, md-toc
, mdformat
, newversion
, poetry-core
, pyparsing
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mypy-boto3-builder";
  version = "7.5.5";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "vemel";
    repo = "mypy_boto3_builder";
    rev = version;
    hash = "sha256-rv0c0QoXOd7aSOLhGDGfq4v0bnGBOJhGhZVNhS5hgOs=";
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
    newversion
    pyparsing
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mypy_boto3_builder"
  ];

  disabledTests = [
    # Tests require network access
    "TestBotocoreChangelogChangelog"
  ];

  meta = with lib; {
    description = "Type annotations builder for boto3";
    homepage = "https://github.com/youtype/mypy_boto3_builder";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
