{ lib
, buildPythonPackage
, django
, django-extensions
, django-js-asset
, fetchFromGitHub
, pillow
, python
, pythonOlder
, selenium
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-ckeditor";
  version = "6.7";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django-ckeditor";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mZQ5s3YbumYmT0zRWPFIvzt2TbtDLvVcJjZVAwn31E8=";
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
    changelog = "https://github.com/django-ckeditor/django-ckeditor/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
