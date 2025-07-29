{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyjwt,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  pythonOlder,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ibm-cloud-sdk-core";
  version = "3.24.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "IBM";
    repo = "python-sdk-core";
    tag = "v${version}";
    hash = "sha256-xw7jEDr/5Qmd4+riAqFzTTFfmX/gQdlbzNZ8pua0hIs=";
  };

  pythonRelaxDeps = [ "requests" ];

  build-system = [ setuptools ];

  dependencies = [
    pyjwt
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # Various tests try to access credential files which are not included with the source distribution
    "test_configure_service"
    "test_cp4d_authenticator"
    "test_cwd"
    "test_files_dict"
    "test_files_duplicate_parts"
    "test_files_list"
    "test_get_authenticator"
    "test_gzip_compression_external"
    "test_iam"
    "test_read_external_sources_2"
    "test_retry_config_external"
    # Tests require network access
    "test_tls_v1_2"
  ];

  disabledTestPaths = [
    # Tests require credentials
    "test_integration/"
  ];

  meta = with lib; {
    description = "Client library for the IBM Cloud services";
    homepage = "https://github.com/IBM/python-sdk-core";
    changelog = "https://github.com/IBM/python-sdk-core/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}
