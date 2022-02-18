{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pydantic
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pycfmodel";
  version = "0.16.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Skyscanner";
    repo = pname;
    rev = version;
    hash = "sha256-hOe6BH8aSGJ7YeraiCsJ10mbeGbFGaR3Bt5fh6M8iWI=";
  };

  propagatedBuildInputs = [
    pydantic
  ];

  checkInputs = [
    httpx
    pytestCheckHook
  ];

  disabledTests = [
    # Test require network access
    "test_cloudformation_actions"
    "test_auxiliar_cast"
    "test_valid_es_domain_from_aws_documentation_examples_resource_can_be_built"
    "test_valid_opensearch_domain_from_aws_documentation_examples_resource_can_be_built"
  ];

  pythonImportsCheck = [
    "pycfmodel"
  ];

  meta = with lib; {
    description = "Model for Cloud Formation scripts";
    homepage = "https://github.com/Skyscanner/pycfmodel";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
