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
  version = "2.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9663b6eca64777b68d6d4142efad8597fe9a685924673b25aa8a1dcff4db00c3";
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
