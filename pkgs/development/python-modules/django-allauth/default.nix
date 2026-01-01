{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  python,

  # build-system
  setuptools,
  setuptools-scm,

  # build-time dependencies
  gettext,

  # dependencies
  asgiref,
  django,

  # optional-dependencies
  fido2,
  oauthlib,
  python3-openid,
  python3-saml,
  requests,
  requests-oauthlib,
  pyjwt,
  qrcode,

  # tests
  django-ninja,
  djangorestframework,
  pillow,
  psycopg2,
  pytest-asyncio,
  pytest-django,
  pytestCheckHook,
  pyyaml,

  # passthru tests
  dj-rest-auth,
}:

buildPythonPackage rec {
  pname = "django-allauth";
<<<<<<< HEAD
  version = "65.13.1";
=======
  version = "65.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "allauth";
    repo = "django-allauth";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-tmCOJ15l8UnvFZFCiqH2ACBeIEDqYKNwf9gkCUHTKPE=";
=======
    hash = "sha256-LM9XU8oMzg2WlYnwPmmZY+8gzZWT1br2ciZ7gCTbH7I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ gettext ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asgiref
    django
  ];

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} -m django compilemessages
  '';

  optional-dependencies = {
<<<<<<< HEAD
    headless = [
      pyjwt
    ]
    ++ pyjwt.optional-dependencies.crypto;
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    headless-spec = [ pyyaml ];
    idp-oidc = [
      oauthlib
      pyjwt
    ]
    ++ pyjwt.optional-dependencies.crypto;
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
    ]
    ++ pyjwt.optional-dependencies.crypto;
    steam = [ python3-openid ];
  };

  pythonImportsCheck = [ "allauth" ];

  nativeCheckInputs = [
    django-ninja
    djangorestframework
    pillow
    psycopg2
    pytest-asyncio
    pytest-django
    pytestCheckHook
    pyyaml
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  disabledTests = [
    # Tests require network access
    "test_login"
  ];

  passthru.tests = { inherit dj-rest-auth; };

  meta = {
    description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication";
    changelog = "https://codeberg.org/allauth/django-allauth/src/tag/${src.tag}/ChangeLog.rst";
    downloadPage = "https://codeberg.org/allauth/django-allauth";
    homepage = "https://allauth.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
