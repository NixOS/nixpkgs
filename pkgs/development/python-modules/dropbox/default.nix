{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, requests
, setuptools
, six
, stone
, mock
, pytest-mock
, pytestCheckHook
, sphinxHook
}:

buildPythonPackage rec {
  pname = "dropbox";
  version = "11.34.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
  outputs = ["out" "doc"];

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dropbox-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-bahl78c0MGu4AoANO/FWYq/DQWPC4T8WVdRHKzwg444=";
  };

  propagatedBuildInputs = [
    requests
    setuptools
    six
    stone
  ];

  checkInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner == 5.2.0'," ""
  '';

  doCheck = true;

  pythonImportsCheck = [
    "dropbox"
  ];
  nativeBuildInputs = [ sphinxHook ];

  # Set SCOPED_USER_DROPBOX_TOKEN environment variable to a valid value.
  disabledTests = [
    "test_default_oauth2_urls"
    "test_bad_auth"
    "test_multi_auth"
    "test_refresh"
    "test_app_auth"
    "test_downscope"
    "test_rpc"
    "test_upload_download"
    "test_bad_upload_types"
    "test_clone_when_user_linked"
    "test_with_path_root_constructor"
    "test_path_root"
    "test_path_root_err"
    "test_versioned_route"
    "test_team"
    "test_as_user"
    "test_as_admin"
    "test_clone_when_team_linked"
  ];

  meta = with lib; {
    description = "Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = "https://github.com/dropbox/dropbox-sdk-python";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
