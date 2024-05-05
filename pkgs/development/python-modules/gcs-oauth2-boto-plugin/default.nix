{ lib
, boto
, buildPythonPackage
, fasteners
, fetchFromGitHub
, freezegun
, google-auth
, google-auth-httplib2
, google-reauth
, httplib2
, oauth2client
, pyopenssl
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, retry-decorator
, rsa
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "gcs-oauth2-boto-plugin";
  version = "3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "gcs-oauth2-boto-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-lEcty0Eqe2FvjMWkPBYHHM9eL5Wsqr53TGSS9bfCBrQ=";
  };

  pythonRelaxDeps = [
    "google-auth"
    "rsa"
  ];

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  dependencies = [
    boto
    freezegun
    google-auth
    google-reauth
    google-auth-httplib2
    httplib2
    oauth2client
    pyopenssl
    retry-decorator
    rsa
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gcs_oauth2_boto_plugin"
  ];

  meta = with lib; {
    description = "Auth plugin allowing use the use of OAuth 2.0 credentials for Google Cloud Storage";
    homepage = "https://github.com/GoogleCloudPlatform/gcs-oauth2-boto-plugin";
    changelog = "https://github.com/GoogleCloudPlatform/gcs-oauth2-boto-plugin/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
