{
  lib,
  buildPythonPackage,
  django,
  django-allauth,
  djangorestframework,
  djangorestframework-simplejwt,
  fetchFromGitHub,
  fetchpatch,
  python,
  responses,
  setuptools,
  unittest-xml-reporting,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "dj-rest-auth";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iMerica";
    repo = "dj-rest-auth";
    tag = version;
    hash = "sha256-bus7Sf5H4PA5YFrkX7hbALOq04koDz3KTO42hHFJPhw=";
  };

  patches = [
    # See https://github.com/iMerica/dj-rest-auth/pull/683
    (fetchpatch {
      name = "djangorestframework-simplejwt_5.5_compatibility.patch";
      url = "https://github.com/iMerica/dj-rest-auth/commit/cc5587e4e3f327697709f3f0d491650bff5464e7.diff";
      hash = "sha256-2LahibxuNECAfjqsbNs2ezaWt1VH0ZBNwSNWCZwIe8I=";
    })
    # Add compatibility with django-allauth v65.4
    # See https://github.com/iMerica/dj-rest-auth/pull/681
    (fetchpatch {
      name = "django-allauth_65.4_compatibility.patch";
      url = "https://github.com/iMerica/dj-rest-auth/commit/59b8cab7e2f4e3f2fdc11ab3b027a32cad45deef.patch";
      hash = "sha256-CH85vB3EOQvFxx+ZP2LYI4LEvaZ+ccLdXZGuAvEfStc=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "==" ">="
  '';

  build-system = [ setuptools ];

  buildInputs = [ django ];

  dependencies = [ djangorestframework ];

  optional-dependencies.with_social = [
    django-allauth
  ]
  ++ django-allauth.optional-dependencies.socialaccount;

  nativeCheckInputs = [
    djangorestframework-simplejwt
    responses
    unittest-xml-reporting
  ]
  ++ optional-dependencies.with_social;

  checkInputs = [
    pytestCheckHook
    pytest-django
  ];

  env.DJANGO_SETTINGS_MODULE = "dj_rest_auth.tests.settings";

  preCheck = ''
    # Make tests module available for the checkPhase
    export PYTHONPATH=$out/${python.sitePackages}/dj_rest_auth:$PYTHONPATH
  '';

  disabledTests = [
    # Test connects to graph.facebook.com
    "TestSocialLoginSerializer"
    # claim[user_id] is "1" (str) vs 1 (int)
    "test_custom_jwt_claims"
    "test_custom_jwt_claims_cookie_w_authentication"
  ];

  disabledTestPaths = [
    # Test fails with > django-allauth 65.4
    # See: https://github.com/iMerica/dj-rest-auth/pull/681#issuecomment-3034953311
    "dj_rest_auth/tests/test_social.py"
  ];

  pythonImportsCheck = [ "dj_rest_auth" ];

  meta = {
    description = "Authentication for Django Rest Framework";
    homepage = "https://github.com/iMerica/dj-rest-auth";
    changelog = "https://github.com/iMerica/dj-rest-auth/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
