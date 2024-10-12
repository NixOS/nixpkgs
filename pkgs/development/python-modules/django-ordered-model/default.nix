{ lib
, buildPythonPackage
, fetchPypi
, isPy27

# buildtime
, setuptools

# runtime
, django

# tests
, python
, djangorestframework
}:

buildPythonPackage rec {
  pname = "django-ordered-model";
  version = "3.7.4";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8li5diUlwApTAJ6C+Li/KjqjFei0U+KB6P27/iuMs7o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    djangorestframework
  ];

  propagatedBuildInputs = [
    django
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test --settings tests.settings
    runHook postCheck
  '';

  pythonImportsCheck = [ "ordered_model" ];

  meta = with lib; {
    description = "Allow models to be ordered and provide a simple admin interface for reordering them.";
    homepage = "https://github.com/django-ordered-model/django-ordered-model";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
    platforms = platforms.linux;
  };
}
