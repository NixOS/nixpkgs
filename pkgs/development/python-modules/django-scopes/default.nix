{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, pytestCheckHook
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-scopes";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.2.0.post1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-scopes";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-CtToztLVvSb91pMpPNL8RysQJzlRkeXuQbpvbkX3jfM=";
=======
    # No 1.2.0.post1 tag, see https://github.com/raphaelm/django-scopes/issues/27
    rev = "0b93cdb6a8335cb02a8ea7296511358ba841d137";
    hash = "sha256-djptJRkW1pfVbxhhs58fJA4d8dKZuvYRy01Aa3Btr+k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    django
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "django_scopes" ];

  meta = with lib; {
    description = "Safely separate multiple tenants in a Django database";
    homepage = "https://github.com/raphaelm/django-scopes";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie ];
  };
}
