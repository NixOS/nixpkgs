{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build time
<<<<<<< HEAD
, pdm-backend
=======
, pdm-pep517
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# runtime
, packaging

# tests
, pytestCheckHook
}:

let
  pname = "findpython";
<<<<<<< HEAD
  version = "0.3.1";
=======
  version = "0.2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-diH4qcGZpw0hmDHN2uuEyn6D4guDWBcr/0eHGhil7aQ=";
  };

  nativeBuildInputs = [
    pdm-backend
=======
    hash = "sha256-4P1HO0Jl5+DnhD7Hb+rIwMRBuGlXH0Zb7+nmlZSQaf4=";
  };

  nativeBuildInputs = [
    pdm-pep517
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "findpython"
  ];

  meta = with lib; {
    description = "A utility to find python versions on your system";
    homepage = "https://github.com/frostming/findpython";
    changelog = "https://github.com/frostming/findpython/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
