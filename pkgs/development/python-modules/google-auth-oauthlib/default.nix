{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  google-auth,
  requests-oauthlib,
  click,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "google-auth-oauthlib";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-auth-library-python-oauthlib";
    rev = "v${version}";
    sha256 = "sha256-nkXS1vNsq7k30EmNHclRblsmGTMYuIAaHuaVDORqRmc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-auth
    requests-oauthlib
  ];

  optional-dependencies = {
    tool = [ click ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ optional-dependencies.tool;

  disabledTests = [
    # Flaky test. See https://github.com/NixOS/nixpkgs/issues/288424#issuecomment-1941609973.
    "test_run_local_server_occupied_port"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # This test fails if the hostname is not associated with an IP (e.g., in `/etc/hosts`).
    "test_run_local_server_bind_addr"
  ];

  pythonImportsCheck = [ "google_auth_oauthlib" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    changelog = "https://github.com/googleapis/google-auth-library-python-oauthlib/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sarahec
      terlar
    ];
    mainProgram = "google-oauthlib-tool";
  };
}
