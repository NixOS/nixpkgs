{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow-dataclass,
  marshmallow,
  pdm-backend,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  requests,
  responses,
  setuptools,
  typing-extensions,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "pygitguardian";
  version = "1.15.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "GitGuardian";
    repo = "py-gitguardian";
    rev = "refs/tags/v${version}";
    hash = "sha256-jmjlNGyGYsiwQ0qi8KiSUI38J4n1ZTzqxzY9Bn9OdqY=";
  };

  pythonRelaxDeps = [
    "marshmallow-dataclass"
    "setuptools"
  ];

  build-system = [
    pdm-backend
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  dependencies = [
    marshmallow
    marshmallow-dataclass
    requests
    setuptools
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
    responses
  ];

  pythonImportsCheck = [ "pygitguardian" ];

  disabledTests = [
    # Tests require an API key
    "test_bogus_rate_limit"
    "test_compute_sca_files"
    "test_content_scan_exceptions"
    "test_content_scan"
    "test_create_honeytoken"
    "test_create_jwt"
    "test_extra_headers"
    "test_health_check"
    "test_multi_content_exceptions"
    "test_multi_content_scan"
    "test_multiscan_parameters"
    "test_quota_overview"
    "test_rate_limit"
    "test_read_metadata_bad_response"
    "test_sca_client_scan_diff"
    "test_sca_scan_all_with_params"
    "test_sca_scan_directory_invalid_tar"
    "test_sca_scan_directory"
    "test_versions_from_headers"
  ];

  meta = with lib; {
    description = "Library to access the GitGuardian API";
    homepage = "https://github.com/GitGuardian/py-gitguardian";
    changelog = "https://github.com/GitGuardian/py-gitguardian/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
