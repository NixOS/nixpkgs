{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-oauthlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ovh";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0xHwjsF7YsxhIWs9rPA+6J+VodqQNqWV2sKfydeYuCc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ovh" ];

  disabledTests = [
    # Tests require network access
    "test_config_from_files"
    "test_config_from_given_config_file"
    "test_config_from_invalid_ini_file"
    "test_config_from_only_one_file"
    "test_endpoints"
    # Tests require API key
    "test_config_oauth2"
    "test_config_invalid_both"
    "test_config_invalid_oauth2"
    "test_config_incompatible_oauth2"
  ];

  meta = with lib; {
    description = "Thin wrapper around OVH's APIs";
    homepage = "https://github.com/ovh/python-ovh";
    changelog = "https://github.com/ovh/python-ovh/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ makefu ];
  };
}
