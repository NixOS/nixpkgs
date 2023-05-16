{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, orjson
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, unittestCheckHook
, pythonOlder
, redis
}:

buildPythonPackage rec {
  pname = "karton-core";
<<<<<<< HEAD
  version = "5.2.0";
=======
  version = "5.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-1Bv0e218cvLuv/go0L13C39fFAeo0FJeCoU+XFUBhzk=";
=======
    hash = "sha256-TKO0l0AKsC9MMB58ao/EXcJ9k/J3y3S9tc127H7vA6w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    boto3
<<<<<<< HEAD
    orjson
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    redis
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "karton.core"
  ];

  meta = with lib; {
    description = "Distributed malware processing framework";
    homepage = "https://karton-core.readthedocs.io/";
    changelog = "https://github.com/CERT-Polska/karton/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ chivay fab ];
  };
}
