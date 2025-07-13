{
  lib,
  blinker,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  mock,
  pyjwt,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
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

  disabled = pythonOlder "3.8";

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
  ++ lib.flatten (lib.attrValues optional-dependencies);

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
