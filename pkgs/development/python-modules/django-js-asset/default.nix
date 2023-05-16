{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, hatchling
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, django
, python
}:

buildPythonPackage rec {
  pname = "django-js-asset";
<<<<<<< HEAD
  version = "2.1";
  format = "pyproject";
=======
  version = "2.0";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-rxJ9TgVBiJByiFSLTg/dtAR31Fs14D4sh2axyBcKGTU=";
  };

  nativeBuildInputs = [
    hatchling
  ];

=======
    hash = "sha256-YDOmbqB0xDBAlOSO1UBYJ8VfRjJ8Z6Hw1i24DNSrnjw=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    django
  ];

  pythonImportsCheck = [
    "js_asset"
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/manage.py test testapp
    runHook postCheck
  '';

  meta = with lib; {
    description = "Script tag with additional attributes for django.forms.Media";
    homepage = "https://github.com/matthiask/django-js-asset";
    maintainers = with maintainers; [ hexa ];
    license = with licenses; [ bsd3 ];
  };
}
