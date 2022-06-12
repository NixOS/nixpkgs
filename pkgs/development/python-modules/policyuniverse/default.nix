{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "policyuniverse";
  version = "1.5.0.20220523";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gmcF8KdwGLMU5g1NYgxLKgBLk1yJrWi/dpVETDaY0Vo=";
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
