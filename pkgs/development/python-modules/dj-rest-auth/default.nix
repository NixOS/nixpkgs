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
<<<<<<< HEAD
  version = "4.0.1";
=======
  version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "iMerica";
    repo = "dj-rest-auth";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-+ladx0b/bvvUW8zLjtG8IiWWdfPTqqm/KYbEK9uiFaU=";
=======
    hash = "sha256-wkbFUrvKhdp2Hd4QkXAvhMiaqSXFD/fgIw03nLPaO5I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
