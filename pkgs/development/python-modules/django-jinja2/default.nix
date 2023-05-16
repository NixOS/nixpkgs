{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, django
, jinja2
, python
}:

buildPythonPackage rec {
  pname = "django-jinja";
<<<<<<< HEAD
  version = "2.11.0";

  disabled = pythonOlder "3.8";
=======
  version = "2.10.2";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "niwinz";
    repo = "django-jinja";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-0gkv9xinHux8TRiNBLl/JgcimXU3CzysxzGR2jn7OZ4=";
=======
    rev = version;
    hash = "sha256-IZ4HjBQt6K8xbaYfO5DVlGKUVCQ3UciAUpfnqCjzyCE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    django
    jinja2
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} testing/runtests.py

    runHook postCheck
  '';

  meta = {
    description = "Simple and nonobstructive jinja2 integration with Django";
    homepage = "https://github.com/niwinz/django-jinja";
    changelog = "https://github.com/niwinz/django-jinja/blob/${src.rev}/CHANGES.adoc";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
