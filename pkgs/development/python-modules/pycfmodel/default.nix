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
<<<<<<< HEAD
  version = "0.20.3";
=======
  version = "0.20.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Skyscanner";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-dHgd6vnmlg+VXMp7QUZoT2aic1X05lJGm8hDrowALvk=";
=======
    hash = "sha256-TumqpNaxH9YET56PhTXJVG/OQw3syXaYNtHn+Vyh6xI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pydantic
  ];

  nativeCheckInputs = [
    httpx
    pytestCheckHook
  ];

  disabledTests = [
    # Test require network access
    "test_cloudformation_actions"
    "test_auxiliar_cast"
    "test_valid_es_domain_from_aws_documentation_examples_resource_can_be_built"
    "test_valid_opensearch_domain_from_aws_documentation_examples_resource_can_be_built"
    "test_resolve_booleans_different_properties_for_generic_resource"
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
