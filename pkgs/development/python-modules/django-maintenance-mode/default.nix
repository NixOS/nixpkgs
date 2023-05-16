{ lib
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
, buildPythonPackage
, django
, python-fsutil
, python
=======
, buildPythonPackage
, pytest
, django
, python-fsutil
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-maintenance-mode";
  version = "0.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Mcj8O20hCINGf5T3PCG9jq0onSrm4R+Ke5CLMqMDmuU=";
  };

<<<<<<< HEAD
  patches = [
    (fetchpatch {
      name = "fix-broken-test.patch";
      url = "https://github.com/fabiocaccamo/django-maintenance-mode/commit/68cde8d9ceef00eeaa2068f420698c1c562fa9fc.patch";
      hash = "sha256-K/zYYkcnmWGc7Knz4l9PgvUtT0IccPRXc3UFriC1ldc=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    django
    python-fsutil
  ];

<<<<<<< HEAD
  checkPhase = ''
    runHook preCheck

    ${python.interpreter} runtests.py

    runHook postCheck
  '';
=======
  nativeCheckInputs = [
    pytest
  ];

  pythonImportsCheck = [
    "maintenance_mode"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Shows a 503 error page when maintenance-mode is on";
    homepage = "https://github.com/fabiocaccamo/django-maintenance-mode";
    changelog = "https://github.com/fabiocaccamo/django-maintenance-mode/releases/tag/${version}";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd3;
  };
}
