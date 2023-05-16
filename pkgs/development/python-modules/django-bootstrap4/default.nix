{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
<<<<<<< HEAD
, hatchling

# non-propagates
, django
=======
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# dependencies
, beautifulsoup4

# tests
<<<<<<< HEAD
=======
, django
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, python
}:

buildPythonPackage rec {
  pname = "django-bootstrap4";
<<<<<<< HEAD
  version = "23.2";
=======
  version = "3.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap4";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-RYGwi+hRfTqPAikrv33w27v1/WLwRvXexSusJKdr2o8=";
  };

  nativeBuildInputs = [
    hatchling
=======
    rev = "v${version}";
    hash = "sha256-5t6b/1921AMDqoYg7XC2peGxOBFE8XlvgGjHnTlQa4c=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    beautifulsoup4
  ];

  pythonImportsCheck = [
    "bootstrap4"
  ];

  nativeCheckInputs = [
    (django.override { withGdal = true; })
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} manage.py test -v1 --noinput
    runHook postCheck
  '';

  meta = with lib; {
    description = "Bootstrap 4 integration with Django";
    homepage = "https://github.com/zostera/django-bootstrap4";
    changelog = "https://github.com/zostera/django-bootstrap4/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
