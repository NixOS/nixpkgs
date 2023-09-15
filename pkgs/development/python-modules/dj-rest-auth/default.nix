{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, django-allauth
, djangorestframework
, djangorestframework-simplejwt
, responses
, unittest-xml-reporting
, python
}:

buildPythonPackage rec {
  pname = "dj-rest-auth";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "iMerica";
    repo = "dj-rest-auth";
    rev = "refs/tags/${version}";
    hash = "sha256-GSNY8AC4KvxHxq+18qTDgSlyKpJvq0kSVRp7NdMHe18=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "coveralls>=1.11.1" "" \
      --replace "==" ">="
  '';

  buildInputs = [
    django
  ];

  propagatedBuildInputs = [
    djangorestframework
  ];

  passthru.optional-dependencies.with_social = [
    django-allauth
  ];

  nativeCheckInputs = [
    djangorestframework-simplejwt
    responses
    unittest-xml-reporting
  ] ++ passthru.optional-dependencies.with_social;

  preCheck = ''
    # connects to graph.facebook.com
    substituteInPlace dj_rest_auth/tests/test_serializers.py \
      --replace "def test_http_error" "def dont_test_http_error"
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
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
