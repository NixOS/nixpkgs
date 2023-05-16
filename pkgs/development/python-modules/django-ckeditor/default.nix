{ lib
, buildPythonPackage
, django
<<<<<<< HEAD
, django-extensions
, django-js-asset
, fetchFromGitHub
, pillow
, python
, pythonOlder
, selenium
, setuptools-scm
=======
, django-js-asset
, fetchFromGitHub
, python
, setuptools-scm
, django-extensions
, selenium
, pillow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "django-ckeditor";
<<<<<<< HEAD
  version = "6.7";
  format = "pyproject";

  disabled = pythonOlder "3.8";

=======
  version = "6.5.1";
  format = "pyproject";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "django-ckeditor";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-mZQ5s3YbumYmT0zRWPFIvzt2TbtDLvVcJjZVAwn31E8=";
=======
    hash = "sha256-Gk8mAG0WIMQZolaE1sRDmzSkfiNHi/BWiotEtIC4WLk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    django-js-asset
    pillow
  ];

  DJANGO_SETTINGS_MODULE = "ckeditor_demo.settings";

  checkInputs = [
    django-extensions
    selenium
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test
    runHook postCheck
  '';

  pythonImportsCheck = [
    "ckeditor"
  ];

  meta = with lib; {
    description = " Django admin CKEditor integration";
    homepage = "https://github.com/django-ckeditor/django-ckeditor";
<<<<<<< HEAD
    changelog = "https://github.com/django-ckeditor/django-ckeditor/blob/${version}/CHANGELOG.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
