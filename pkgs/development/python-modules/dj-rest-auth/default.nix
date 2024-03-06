{ lib
, buildPythonPackage
, django
, django-allauth
, djangorestframework
, djangorestframework-simplejwt
, fetchFromGitHub
, fetchpatch
, python
, pythonOlder
, responses
, setuptools
, unittest-xml-reporting
}:

buildPythonPackage rec {
  pname = "dj-rest-auth";
  version = "5.0.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "iMerica";
    repo = "dj-rest-auth";
    rev = "refs/tags/${version}";
    hash = "sha256-TqeNpxXn+v89fEiJ4AVNhp8blCfYQKFQfYmZ6/QlRbQ=";
  };

  patches = [
    # https://github.com/iMerica/dj-rest-auth/pull/597
    (fetchpatch {
      name = "disable-email-confirmation-ratelimit-in-tests-to-support-new-allauth.patch";
      url = "https://github.com/iMerica/dj-rest-auth/commit/c8f19e18a93f4959da875f9c5cdd32f7d9363bba.patch";
      hash = "sha256-Y/YBjV+c5Gw1wMR5r/4VnyV/ewUVG0z4pjY/MB4ca9Y=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="
  '';

  nativeBuildInputs = [
    setuptools
  ];

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
    # Test connects to graph.facebook.com
    substituteInPlace dj_rest_auth/tests/test_serializers.py \
      --replace "def test_http_error" "def dont_test_http_error"
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "dj_rest_auth"
  ];

  meta = with lib; {
    description = "Authentication for Django Rest Framework";
    homepage = "https://github.com/iMerica/dj-rest-auth";
    changelog = "https://github.com/iMerica/dj-rest-auth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
