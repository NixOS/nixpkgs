{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, marshmallow-dataclass
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, requests
, responses
, setuptools
, typing-extensions
, vcrpy
}:

buildPythonPackage rec {
  pname = "pygitguardian";
  version = "1.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GitGuardian";
    repo = "py-gitguardian";
    rev = "refs/tags/v${version}";
    hash = "sha256-ybl6QOLb1xE6v0D1C2wKMsSU+r2gWzj24Q4pPIMBsCY=";
  };

  pythonRelaxDeps = [
    "marshmallow-dataclass"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    marshmallow
    marshmallow-dataclass
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
    responses
  ];

  pythonImportsCheck = [
    "pygitguardian"
  ];

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
    "test_sca_client_scan_diff"
    "test_sca_scan_directory_invalid_tar"
    "test_sca_scan_directory"
    "test_versions_from_headers"
  ];

  meta = with lib; {
    description = "Library to access the GitGuardian API";
    homepage = "https://github.com/GitGuardian/py-gitguardian";
    changelog = "https://github.com/GitGuardian/py-gitguardian/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
