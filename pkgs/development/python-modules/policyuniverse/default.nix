{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "policyuniverse";
  version = "1.5.0.20220414";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BtNxU5NdOJfJejN4RpsUJJytWkQxJxbNjnY8hLPb3q0=";
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
