{ lib
, buildPythonPackage
, django
, django-js-asset
, fetchFromGitHub
, python
, setuptools-scm
, django-extensions
, selenium
, pillow
}:

buildPythonPackage rec {
  pname = "django-ckeditor";
  version = "6.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "django-ckeditor";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Gk8mAG0WIMQZolaE1sRDmzSkfiNHi/BWiotEtIC4WLk=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
