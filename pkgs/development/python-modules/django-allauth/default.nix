{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  python,

  # build-system
  setuptools,

  # build-time dependencies
  gettext,

  # dependencies
  asgiref,
  django,

  # optional-dependencies
  fido2,
  python3-openid,
  python3-saml,
  requests,
  requests-oauthlib,
  pyjwt,
  qrcode,

  # tests
  pillow,
  pytestCheckHook,
  pytest-asyncio,
  pytest-django,

  # passthru tests
  dj-rest-auth,
}:

buildPythonPackage rec {
  pname = "django-allauth";
  version = "65.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pennersr";
    repo = "django-allauth";
    tag = version;
    hash = "sha256-IgadrtOQt3oY2U/+JWBs5v97aaWz5oinz5QUdGXBqO4=";
  };

  nativeBuildInputs = [
    gettext
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    asgiref
    django
  ];

  preBuild = ''
    ${python.interpreter} -m django compilemessages
  '';

  optional-dependencies = {
    mfa = [
      fido2
      qrcode
    ];
    openid = [ python3-openid ];
    saml = [ python3-saml ];
    socialaccount = [
      requests
      requests-oauthlib
      pyjwt
    ] ++ pyjwt.optional-dependencies.crypto;
    steam = [ python3-openid ];
  };

  pythonImportsCheck = [ "allauth" ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
    pytest-asyncio
    pytest-django
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTests = [
    # Tests require network access
    "test_login"
  ];

  passthru.tests = {
    inherit dj-rest-auth;
  };

  meta = with lib; {
    changelog = "https://github.com/pennersr/django-allauth/blob/${version}/ChangeLog.rst";
    description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication";
    downloadPage = "https://github.com/pennersr/django-allauth";
    homepage = "https://www.intenct.nl/projects/django-allauth";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
