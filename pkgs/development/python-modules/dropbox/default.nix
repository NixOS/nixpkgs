{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  requests,
  six,
  stone,
  urllib3,
  mock,
  pytest-mock,
  pytestCheckHook,
  sphinxHook,
  sphinx-rtd-theme,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "dropbox";
  version = "12.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dropbox-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-0MDm6NB+0vkN8QRSHvuDYEyYhYQWQD4jsctyd5fLdwE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    six
    stone
    urllib3
  ];

  nativeCheckInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner==5.2.0'," ""
  '';

  doCheck = true;

  pythonImportsCheck = [ "dropbox" ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
    pythonRelaxDepsHook
  ];

  # Version 12.0.0 re-introduced Python 2 support and set some very restrictive version bounds
  # https://github.com/dropbox/dropbox-sdk-python/commit/75596daf316b4a806f18057e2797a15bdf83cf6d
  # This will be the last major version to support Python 2, so version bounds might be more reasonable again in the future.
  pythonRelaxDeps = [
    "requests"
    "stone"
    "urllib3"
  ];

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
    "test_bad_pins"
    "test_bad_pins_session"
  ];

  meta = with lib; {
    description = "Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = "https://github.com/dropbox/dropbox-sdk-python";
    changelog = "https://github.com/dropbox/dropbox-sdk-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
