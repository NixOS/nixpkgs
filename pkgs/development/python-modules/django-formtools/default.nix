{ lib
, buildPythonPackage
, django
, fetchPypi
, python
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-formtools";
  version = "2.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R8s0VSxu/KCIhj1pMoTQT8NuqvNQ6yHhodk14N9SPJM=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  pythonImportsCheck = [
    "formtools"
  ];

  meta = with lib; {
    description = "A set of high-level abstractions for Django forms";
    homepage = "https://github.com/jazzband/django-formtools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
