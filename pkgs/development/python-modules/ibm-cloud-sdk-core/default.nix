{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  version = "3.20.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nE1JIlYlJ5O3L7FQD5L+JvLnVs7nq4Ff6dmHvgXjj0M=";
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

  disabledTests =
    [
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
      # assertion error due to requests brotli support
      "test_http_client"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # Tests are blocking or failing
      "test_abstract_class_instantiation"
      "test_abstract_class_instantiation"
    ];

  disabledTestPaths = [
    "test/test_container_token_manager.py"
    # Tests require credentials
    "test_integration/"
  ];

  meta = with lib; {
    description = "Client library for the IBM Cloud services";
    homepage = "https://github.com/IBM/python-sdk-core";
    changelog = "https://github.com/IBM/python-sdk-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}
