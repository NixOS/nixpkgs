{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "policyuniverse";
  version = "1.5.1.20230526";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-80Q1qkCAD3VwNk0pblPWni3qY/8Dc2YrOLDjPrg/2Os=";
  };

  # Tests are not shipped and there are no GitHub tags
  doCheck = false;

  pythonImportsCheck = [
    "policyuniverse"
  ];

  meta = with lib; {
    description = "Parse and Process AWS IAM Policies, Statements, ARNs and wildcards";
    homepage = "https://github.com/Netflix-Skunkworks/policyuniverse";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
