{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, setuptools-scm
, django
, python
, pythonOlder
=======

# native
, setuptools-scm

# propagated
, django

# tests
, python
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "django-widget-tweaks";
<<<<<<< HEAD
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-/3UIsg75X3R9YGv9cEcoPw3IN2vkhUb+HCy68813d2E=";
=======
  version = "1.4.12";

  src = fetchFromGitHub { # package from Pypi missing runtests.py
    owner = "jazzband";
    repo = pname;
    rev = version;
    sha256 = "1rhn2skx287k6nnkxlwvl9snbia6w6z4c2rqg22hwzbz5w05b24h";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "Tweak the form field rendering in templates, not in python-level form definitions";
    homepage = "https://github.com/jazzband/django-widget-tweaks";
    changelog = "https://github.com/jazzband/django-widget-tweaks/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ maxxk ];
=======
    description = "Tweak the form field rendering in templates, not in python-level form definitions.";
    homepage = "https://github.com/jazzband/django-widget-tweaks";
    license = licenses.mit;
    maintainers = with maintainers; [
      maxxk
    ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
