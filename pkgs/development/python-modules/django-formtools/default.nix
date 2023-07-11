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
  version = "2.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IfjV2sc38eY2+ooKEJacHDL1JabfonwpWSgnunDZZDo=";
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
