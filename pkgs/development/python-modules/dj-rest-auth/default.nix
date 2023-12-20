{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "5.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "iMerica";
    repo = "dj-rest-auth";
    rev = "refs/tags/${version}";
    hash = "sha256-PTFUZ54vKlufKCQyJb+QB/+hI15r+Z0auTjnc38yMLg=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/iMerica/dj-rest-auth/pull/561
      url = "https://github.com/iMerica/dj-rest-auth/commit/be0cf53d94582183320b0994082f0a312c1066d9.patch";
      hash = "sha256-BhZ7BWW8m609cVn1WCyPfpZq/706YVZAesrkcMKTD3A=";
    })
  ];

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
