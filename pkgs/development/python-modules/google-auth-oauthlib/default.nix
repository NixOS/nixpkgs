{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  mock,
  pytestCheckHook,
  google-auth,
  requests-oauthlib,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "google-auth-oauthlib";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "google_auth_oauthlib";
    inherit version;
    hash = "sha256-r9DK0JKi6qU82OgphVfW3hA0xstKdAUAtTV7ZIr5cmM=";
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
  ] ++ optional-dependencies.tool;

  disabledTests =
    [
      # Flaky test. See https://github.com/NixOS/nixpkgs/issues/288424#issuecomment-1941609973.
      "test_run_local_server_occupied_port"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # This test fails if the hostname is not associated with an IP (e.g., in `/etc/hosts`).
      "test_run_local_server_bind_addr"
    ];

  pythonImportsCheck = [ "google_auth_oauthlib" ];

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    changelog = "https://github.com/googleapis/google-auth-library-python-oauthlib/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
    mainProgram = "google-oauthlib-tool";
  };
}
