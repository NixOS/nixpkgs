{
  lib,
  blinker,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  mock,
  pyjwt,
  pytestCheckHook,
  setuptools,

  # for passthru.tests
  django-allauth,
  django-oauth-toolkit,
  google-auth-oauthlib,
  requests-oauthlib,
}:

buildPythonPackage rec {
  pname = "oauthlib";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oauthlib";
    repo = "oauthlib";
    tag = "v${version}";
    hash = "sha256-ZTmR+pTNQaRQMnUA+8hXM5VACRd8Hn62KTNooy5FQyk=";
  };

  nativeBuildInputs = [ setuptools ];

  optional-dependencies = {
    rsa = [ cryptography ];
    signedtoken = [
      cryptography
      pyjwt
    ];
    signals = [ blinker ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # too narrow time comparison issues
    "test_fetch_access_token"
  ];

  pythonImportsCheck = [ "oauthlib" ];

  passthru.tests = {
    inherit
      django-allauth
      django-oauth-toolkit
      google-auth-oauthlib
      requests-oauthlib
      ;
  };

  meta = with lib; {
    changelog = "https://github.com/oauthlib/oauthlib/blob/${src.tag}/CHANGELOG.rst";
    description = "Generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
    homepage = "https://github.com/oauthlib/oauthlib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ prikhi ];
  };
}
