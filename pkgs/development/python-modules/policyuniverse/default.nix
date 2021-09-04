{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "policyuniverse";
  version = "1.4.0.20210819";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RBRUR9Rzw3/yd2ZnteEBigDApJPBagpIk5lSGzeGqL4=";
  };

  # Tests are not shipped and there are no GitHub tags
  doCheck = false;

  pythonImportsCheck = [ "policyuniverse" ];

  meta = with lib; {
    description = "Parse and Process AWS IAM Policies, Statements, ARNs and wildcards";
    homepage = "https://github.com/Netflix-Skunkworks/policyuniverse";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
