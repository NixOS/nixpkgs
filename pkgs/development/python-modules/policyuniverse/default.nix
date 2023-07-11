{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "policyuniverse";
  version = "1.5.1.20230703";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wn/ctnvn7SxB79Jlg+Eqsk3y8bHYKMi4+NE4Rr0E4N4=";
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
