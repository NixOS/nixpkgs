{ lib
, appdirs
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, marshmallow
, pytest-datafiles
, pytest-vcr
, pytestCheckHook
, python-box
, python-dateutil
, requests
, requests-pkcs12
, responses
, restfly
, semver
}:

buildPythonPackage rec {
  pname = "pytenable";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "tenable";
    repo = "pyTenable";
    rev = version;
    sha256 = "19vhy7mf972545abydywyig82gkxalp6sfwinvj71hzbihwwzjpq";
  };

  propagatedBuildInputs = [
    semver
  ];

  buildInputs = [
    appdirs
    defusedxml
    marshmallow
    python-box
    python-dateutil
    requests
    requests-pkcs12
    restfly
  ];

  checkInputs = [
    responses
    pytest-datafiles
    pytest-vcr
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests that requires a Docker container
    "test_uploads_docker_push_name_typeerror"
    "test_uploads_docker_push_tag_typeerror"
    "test_uploads_docker_push_cs_name_typeerror"
    "test_uploads_docker_push_cs_tag_typeerror"
  ];

  pythonImportsCheck = [ "tenable" ];

  meta = with lib; {
    description = "Python library for the Tenable.io and TenableSC API";
    homepage = "https://github.com/tenable/pyTenable";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
