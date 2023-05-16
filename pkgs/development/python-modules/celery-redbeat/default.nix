<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
=======
{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, python-dateutil
, celery
, redis
, tenacity
, pytestCheckHook
<<<<<<< HEAD
, pytz
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fakeredis
, mock
}:

buildPythonPackage rec {
  pname = "celery-redbeat";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "redbeat";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-WW/OYa7TWEKkata1eULir29wHaCnavBJebn4GrBzmWY=";
  };

  patches = [
    (fetchpatch {
      # celery 5.3.0 support
      url = "https://github.com/sibson/redbeat/commit/4240e17172a4d9d2744d5c4da3cfca0e0a024e2e.patch";
      hash = "sha256-quEfSFhv0sIpsKHX1CpFhbMC8LYXA8NASWYU8MMYPSk=";
    })
  ];

  propagatedBuildInputs = [
    celery
    python-dateutil
=======
    hash = "sha256-pu4umhfNFZ30bQu5PcT2LYN4WGzFj4p4/qHm3pVIV+c=";
  };

  propagatedBuildInputs = [
    python-dateutil
    celery
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    redis
    tenacity
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    fakeredis
    mock
    pytestCheckHook
    pytz
=======
    pytestCheckHook
    fakeredis
    mock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [ "redbeat" ];

  meta = with lib; {
    description = "Database-backed Periodic Tasks";
    homepage = "https://github.com/celery/django-celery-beat";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
