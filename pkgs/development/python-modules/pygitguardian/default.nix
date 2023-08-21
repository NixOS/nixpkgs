{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, marshmallow-dataclass
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools
, typing-extensions
, vcrpy
}:

buildPythonPackage rec {
  pname = "pygitguardian";
  version = "1.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GitGuardian";
    repo = "py-gitguardian";
    rev = "refs/tags/v${version}";
    hash = "sha256-lDs2H5GUf3fhTSX+20dD0FNW2oirkgQQk5t7GKSnKe4=";
  };

  nativeBuildInputs = [
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
    "test_health_check"
    "test_multi_content_scan"
    "test_content_scan_exceptions"
    "test_multi_content_exceptions"
    "test_content_scan"
    "test_extra_headers"
    "test_multiscan_parameters"
    "test_quota_overview"
    "test_versions_from_headers"
    "test_create_honeytoken"
    "test_create_jwt"
  ];

  meta = with lib; {
    description = "Library to access the GitGuardian API";
    homepage = "https://github.com/GitGuardian/py-gitguardian";
    changelog = "https://github.com/GitGuardian/py-gitguardian/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
