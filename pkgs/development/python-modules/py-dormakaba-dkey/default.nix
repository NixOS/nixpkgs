{ lib
, bleak
, bleak-retry-connector
, buildPythonPackage
, cryptography
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
, pythonOlder
, setuptools
, wheel
=======
, pythonOlder
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "py-dormakaba-dkey";
  version = "1.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1jIsKQa27XNVievU02jjanRWFtJDYsHolgPBab6qpM0=";
  };

<<<<<<< HEAD
  patches = [
    # https://github.com/emontnemery/py-dormakaba-dkey/pull/45
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/emontnemery/py-dormakaba-dkey/commit/cfda4be71d39f2cfd1c0d4f7fff9018050c57f1a.patch";
      hash = "sha256-JGsaLQNbUfz0uK/MeGnR2XTJDs4RnTOEg7BavfDPArg=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
=======
  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    cryptography
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "py_dormakaba_dkey"
  ];

  meta = with lib; {
    description = "Library to interact with a Dormakaba dkey lock";
    homepage = "https://github.com/emontnemery/py-dormakaba-dkey";
    changelog = "https://github.com/emontnemery/py-dormakaba-dkey/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
