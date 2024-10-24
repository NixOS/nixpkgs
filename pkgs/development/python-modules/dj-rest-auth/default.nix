{
  lib,
  buildPythonPackage,
  django,
  django-allauth,
  djangorestframework,
  djangorestframework-simplejwt,
  fetchFromGitHub,
  python,
  pythonOlder,
  responses,
  setuptools,
  unittest-xml-reporting,
}:

buildPythonPackage rec {
  pname = "dj-rest-auth";
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iMerica";
    repo = "dj-rest-auth";
    rev = "refs/tags/${version}";
    hash = "sha256-fNy1uN3oH54Wd9+EqYpiV0ot1MbSSC7TZoAARQeR81s=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "==" ">="
    substituteInPlace dj_rest_auth/tests/test_api.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  build-system = [ setuptools ];

  buildInputs = [ django ];

  dependencies = [ djangorestframework ];

  optional-dependencies.with_social = [ django-allauth ];

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
