{ lib
, buildPythonPackage
, django
, fetchPypi
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "django-stubs-ext";
<<<<<<< HEAD
  version = "4.2.2";
=======
  version = "4.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-xp0cxG8cTDt4lLaFpQIsKbKjbHz7UuI3YurzV+v8LJg=";
  };

=======
    hash = "sha256-d4nwyuynFS/vB61rlN7HMQoF0Ljat395eeGdsAN7USc=";
  };

  # setup.cfg tries to pull in nonexistent LICENSE.txt file
  postPatch = "rm setup.cfg";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    django
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "django_stubs_ext"
  ];

  meta = with lib; {
    description = "Extensions and monkey-patching for django-stubs";
    homepage = "https://github.com/typeddjango/django-stubs";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
