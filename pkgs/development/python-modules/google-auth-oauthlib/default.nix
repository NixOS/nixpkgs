{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, click
, mock
, pytestCheckHook
, google-auth
, requests-oauthlib
, pythonOlder
, setuptools
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

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-auth
    requests-oauthlib
  ];

  passthru.optional-dependencies = {
    tool = [
      click
    ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = lib.optionals stdenv.isDarwin [
    # This test fails if the hostname is not associated with an IP (e.g., in `/etc/hosts`).
    "test_run_local_server_bind_addr"
  ];

  pythonImportsCheck = [
    "google_auth_oauthlib"
  ];

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/googleapis/google-auth-library-python-oauthlib";
    changelog = "https://github.com/googleapis/google-auth-library-python-oauthlib/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
