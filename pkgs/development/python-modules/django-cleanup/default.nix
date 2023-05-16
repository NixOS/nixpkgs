{ lib
, buildPythonPackage
, fetchPypi
, django
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-cleanup";
<<<<<<< HEAD
  version = "8.0.0";
=======
  version = "7.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-xzmgVUTh5I3ISIcchw2/FZX4Uz0kUjvGc2DkNWLtrw0=";
=======
    hash = "sha256-KKlp+InGYeug2UOJeGk5gPCUgsl5g70I7lKVXa6NceQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    django
  ];

  meta = with lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = "https://github.com/un1t/django-cleanup";
    changelog = "https://github.com/un1t/django-cleanup/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
