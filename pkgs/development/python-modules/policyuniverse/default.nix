{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "policyuniverse";
  version = "1.5.1.20231109";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dOVtQQVgkVwsUTLjYbATDkv/4xKi9FIw6sUNfAlLxAo=";
  };

  # Tests are not shipped and there are no GitHub tags
  doCheck = false;

  pythonImportsCheck = [ "policyuniverse" ];

  meta = {
    description = "Parse and Process AWS IAM Policies, Statements, ARNs and wildcards";
    homepage = "https://github.com/Netflix-Skunkworks/policyuniverse";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
