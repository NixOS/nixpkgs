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
<<<<<<< HEAD
  version = "2.4.1";
=======
  version = "2.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-IfjV2sc38eY2+ooKEJacHDL1JabfonwpWSgnunDZZDo=";
=======
    hash = "sha256-3rkyvlWx2UGeN9xNZd+/640we3HIwR/VLxWaul/A3u0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
