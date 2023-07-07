{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "ovh";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EI+bWjtHEZPOSkWJx3gvS8y//gugMWl3TrBHKsKO9nk=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ovh"
  ];

  disabledTests = [
    # Tests require network access
    "test_config_from_files"
    "test_config_from_given_config_file"
    "test_config_from_invalid_ini_file"
    "test_config_from_only_one_file"
    "test_endpoints"
  ];

  meta = with lib; {
    description = "Thin wrapper around OVH's APIs";
    homepage = "https://github.com/ovh/python-ovh";
    changelog = "https://github.com/ovh/python-ovh/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ makefu ];
  };
}
