{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django-guardian,
  djangorestframework,
  setuptools,
}:

buildPythonPackage rec {
  pname = "djangorestframework-guardian2";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "johnthagen";
    repo = "django-rest-framework-guardian2";
    rev = "refs/tags/v${version}";
    hash = "sha256-LrIhOoBWC3HttjAGbul4zof++OW35pGMyFGZzUpG1Tk=";
  };

  postPatch = ''
    chmod +x manage.py
    patchShebangs manage.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    django-guardian
    djangorestframework
  ];

  checkPhase = ''
    ./manage.py test
  '';

  pythonImportsCheck = [ "rest_framework_guardian" ];

  meta = with lib; {
    description = "Django-guardian support for Django REST Framework";
    homepage = "https://github.com/johnthagen/django-rest-framework-guardian2/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ e1mo ];
  };
}
