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
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KS0tN4M0nysHNKCgIHseHjIqwZPCwJ2PfGE/t8xQHqg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    google-auth
    requests-oauthlib
  ];

  passthru.optional-dependencies = {
    tool = [ click ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.tool;

  disabledTests =
    [
      # Flaky test. See https://github.com/NixOS/nixpkgs/issues/288424#issuecomment-1941609973.
      "test_run_local_server_occupied_port"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # This test fails if the hostname is not associated with an IP (e.g., in `/etc/hosts`).
      "test_run_local_server_bind_addr"
    ];

  pythonImportsCheck = [ "google_auth_oauthlib" ];

  meta = with lib; {
    changelog = "https://github.com/googleapis/google-auth-library-python-oauthlib/blob/v${version}/CHANGELOG.md";
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    license = licenses.asl20;
    mainProgram = "google-oauthlib-tool";
    maintainers = with maintainers; [ terlar ];
  };
}
