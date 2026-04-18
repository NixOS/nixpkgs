{
  lib,
  buildPythonPackage,
  django,
  django-allauth,
  djangorestframework,
  djangorestframework-simplejwt,
  fetchFromGitHub,
  python,
  responses,
  setuptools,
  unittest-xml-reporting,
  pyotp,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "dj-rest-auth";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iMerica";
    repo = "dj-rest-auth";
    tag = finalAttrs.version;
    hash = "sha256-eUcve2KPcLjKKWU7AxQEZ0mokP185E43Xjm4b+4hQzA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "==" ">="
  '';

  build-system = [ setuptools ];

  buildInputs = [ django ];

  dependencies = [ djangorestframework ];

  optional-dependencies = {
    with_social = [
      django-allauth
    ]
    ++ django-allauth.optional-dependencies.socialaccount;
    with_mfa = [
      pyotp
    ];
  };

  nativeCheckInputs = [
    djangorestframework-simplejwt
    pytestCheckHook
    pytest-django
    responses
    unittest-xml-reporting
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  env.DJANGO_SETTINGS_MODULE = "dj_rest_auth.tests.settings";

  preCheck = ''
    # Make tests module available for the checkPhase
    export PYTHONPATH=$out/${python.sitePackages}/dj_rest_auth:$PYTHONPATH
  '';

  disabledTests = [
    # Test connects to graph.facebook.com
    "TestSocialLoginSerializer"
  ];

  pythonImportsCheck = [ "dj_rest_auth" ];

  meta = {
    description = "Authentication for Django Rest Framework";
    homepage = "https://github.com/iMerica/dj-rest-auth";
    changelog = "https://github.com/iMerica/dj-rest-auth/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
