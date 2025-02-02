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

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "==" ">="
  '';

  build-system = [ setuptools ];

  buildInputs = [ django ];

  dependencies = [ djangorestframework ];

  optional-dependencies.with_social = [
    django-allauth
  ] ++ django-allauth.optional-dependencies.socialaccount;

  nativeCheckInputs = [
    djangorestframework-simplejwt
    responses
    unittest-xml-reporting
  ] ++ optional-dependencies.with_social;

  preCheck = ''
    # Test connects to graph.facebook.com
    substituteInPlace dj_rest_auth/tests/test_serializers.py \
      --replace-fail "def test_http_error" "def dont_test_http_error"
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "dj_rest_auth" ];

  meta = with lib; {
    description = "Authentication for Django Rest Framework";
    homepage = "https://github.com/iMerica/dj-rest-auth";
    changelog = "https://github.com/iMerica/dj-rest-auth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
