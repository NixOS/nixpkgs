{ lib
, bottle
, buildPythonPackage
, fetchPypi
, numpy
, pytestCheckHook
, pythonOlder
, pyyaml
, redis
}:

buildPythonPackage rec {
  pname = "jug";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Jug";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-JWE0eSCAaAJ2vyiKGksYUzS3enCIJYCaT3tVV7fP1BA=";
=======
    hash = "sha256-3uK6mWaLEGPFoPuznU+OcnkjFZ+beDoIw0vOC4l5gRg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    bottle
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    pyyaml
    redis
  ];

  pythonImportsCheck = [
    "jug"
  ];

  meta = with lib; {
    description = "A Task-Based Parallelization Framework";
    homepage = "https://jug.readthedocs.io/";
<<<<<<< HEAD
    changelog = "https://github.com/luispedro/jug/blob/v${version}/ChangeLog";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ luispedro ];
  };
}
