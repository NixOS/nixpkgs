{
  lib,
  buildPythonPackage,
  dj-rest-auth,
  django,
  fetchFromGitHub,
  gettext,
  pillow,
  pyjwt,
  pytest-django,
  pytestCheckHook,
  python,
  fido2,
  python3-openid,
  python3-saml,
  pythonOlder,
  qrcode,
  requests-oauthlib,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-allauth";
  version = "64.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pennersr";
    repo = "django-allauth";
    rev = "refs/tags/${version}";
    hash = "sha256-JKjM+zqrXidxpbi+fo6wbvdXlw2oDYH51EsvQ5yp3R8=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ gettext ];

  dependencies = [ django ];

  passthru.optional-dependencies = {
    saml = [ python3-saml ];
    mfa = [
      fido2
      qrcode
    ];
    openid = [ python3-openid ];
    steam = [ python3-openid ];
    socialaccount = [
      requests-oauthlib
      requests
      pyjwt
    ] ++ pyjwt.optional-dependencies.crypto;
  };

  nativeCheckInputs = [
    pillow
    pytestCheckHook
    pytest-django
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preBuild = "${python.interpreter} -m django compilemessages";

  pythonImportsCheck = [ "allauth" ];

  disabledTests = [
    # Tests require network access
    "test_login"
  ];

  passthru.tests = {
    inherit dj-rest-auth;
  };

  meta = with lib; {
    description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication";
    downloadPage = "https://github.com/pennersr/django-allauth";
    homepage = "https://www.intenct.nl/projects/django-allauth";
    changelog = "https://github.com/pennersr/django-allauth/blob/${version}/ChangeLog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
