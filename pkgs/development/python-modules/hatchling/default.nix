{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# runtime
, editables
<<<<<<< HEAD
=======
, importlib-metadata # < 3.8
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, packaging
, pathspec
, pluggy
, tomli
<<<<<<< HEAD
, trove-classifiers
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# tests
, build
, python
, requests
, virtualenv
}:

<<<<<<< HEAD
buildPythonPackage rec {
  pname = "hatchling";
  version = "1.18.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UOmcMRDOCvw/e9ut/xxxwXdY5HZzHCdgeUDPpmhkico=";
  };

  # listed in backend/pyproject.toml
=======
let
  pname = "hatchling";
  version = "1.13.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+NJ1osxyBzUoa3wuK8NdoFdh5tNpXC+kFlUDlfEMU8c=";
  };

  # listed in backend/src/hatchling/ouroboros.py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    editables
    packaging
    pathspec
    pluggy
<<<<<<< HEAD
    trove-classifiers
=======
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  pythonImportsCheck = [
    "hatchling"
    "hatchling.build"
  ];

  # tries to fetch packages from the internet
  doCheck = false;

  # listed in /backend/tests/downstream/requirements.txt
  nativeCheckInputs = [
    build
<<<<<<< HEAD
=======
    packaging
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    requests
    virtualenv
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/downstream/integrate.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Modern, extensible Python build backend";
    homepage = "https://hatch.pypa.io/latest/";
    changelog = "https://github.com/pypa/hatch/releases/tag/hatchling-v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ofek ];
  };
}
