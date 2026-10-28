{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  stone,
  mock,
  pytest-mock,
  pytestCheckHook,
  sphinxHook,
  sphinx-rtd-theme,
}:

buildPythonPackage (finalAttrs: {
  pname = "dropbox";
  version = "12.2.0";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dropbox-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hkfv9+nofc9PMCw7crF3bw4bOFlzbJCHTW8hGxc91Pc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    stone
  ];

  nativeCheckInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dropbox" ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  # Set SCOPED_USER_DROPBOX_TOKEN environment variable to a valid value.
  disabledTests = [
    "test_bad_auth"
    "test_bad_pins"
    "test_bad_pins_session"
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
    "test_upload_auto_content_hash"
  ];

  meta = {
    description = "Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = "https://github.com/dropbox/dropbox-sdk-python";
    changelog = "https://github.com/dropbox/dropbox-sdk-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sfrijters ];
  };
})
