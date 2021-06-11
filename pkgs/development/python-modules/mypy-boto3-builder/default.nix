{ lib
, black
, boto3
, buildPythonPackage
, fetchFromGitHub
, jinja2
, md-toc
, isort
, mdformat
, pyparsing
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mypy-boto3-builder";
  version = "4.14.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vemel";
    repo = "mypy_boto3_builder";
    rev = version;
    sha256 = "sha256-y55bPi70ldd528Olr2atXHm5JHiLNBZ396D9qwbBmkc=";
  };

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

  pythonImportsCheck = [ "mypy_boto3_builder" ];

  meta = with lib; {
    description = "Type annotations builder for boto3";
    homepage = "https://vemel.github.io/mypy_boto3_builder/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
