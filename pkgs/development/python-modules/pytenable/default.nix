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
, requests
, requests-pkcs12
, responses
, restfly
, semver
}:

buildPythonPackage rec {
  pname = "pytenable";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "tenable";
    repo = "pyTenable";
    rev = version;
    sha256 = "12x0w1c4blm73ixv07w90jkydl7d8dx5l27ih9vc1yv9v2zzb53k";
  };

  propagatedBuildInputs = [
    semver
  ];

  buildInputs = [
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
