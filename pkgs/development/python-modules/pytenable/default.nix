{ lib
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, marshmallow
, pytest-datafiles
, pytest-vcr
, pytestCheckHook
, python-box
, python-dateutil
, pythonOlder
, requests
, requests-pkcs12
, responses
, restfly
, semver
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pytenable";
  version = "1.4.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tenable";
    repo = "pyTenable";
    rev = "refs/tags/${version}";
    hash = "sha256-UY3AFnPplmU0jrV4LIKH4+2tcJEFkKMqO2GWVkgaHYE=";
  };

  propagatedBuildInputs = [
    defusedxml
    marshmallow
    python-box
    python-dateutil
    requests
    restfly
    semver
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-datafiles
    pytest-vcr
    pytestCheckHook
    requests-pkcs12
    responses
  ];

  disabledTests = [
    # Disable tests that requires a Docker container
    "test_uploads_docker_push_name_typeerror"
    "test_uploads_docker_push_tag_typeerror"
    "test_uploads_docker_push_cs_name_typeerror"
    "test_uploads_docker_push_cs_tag_typeerror"
  ];

  pythonImportsCheck = [
    "tenable"
  ];

  meta = with lib; {
    description = "Python library for the Tenable.io and TenableSC API";
    homepage = "https://github.com/tenable/pyTenable";
    changelog = "https://github.com/tenable/pyTenable/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
