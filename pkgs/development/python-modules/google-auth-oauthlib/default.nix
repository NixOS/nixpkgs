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

buildPythonPackage (finalAttrs: {
  pname = "google-auth-oauthlib";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-auth-library-python-oauthlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-itnkKMHTpJNjMVvpXYq9V/ybaE/Ekt3uED1IoVebRcg=";
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
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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
    changelog = "https://github.com/googleapis/google-auth-library-python-oauthlib/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sarahec
      terlar
    ];
    mainProgram = "google-oauthlib-tool";
  };
})
