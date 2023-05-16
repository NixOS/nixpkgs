{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, matplotlib
, pydicom
, python-dateutil
, setuptools
}:

let
  deid-data = buildPythonPackage rec {
    pname = "deid-data";
    version = "unstable-2022-12-06";
    format = "pyproject";
    disabled = pythonOlder "3.7";

    nativeBuildInputs = [ setuptools ];
    propagatedBuildInputs = [ pydicom ];

    src = fetchFromGitHub {
      owner = "pydicom";
      repo = "deid-data";
      rev = "5750d25a5048fba429b857c16bf48b0139759644";
      hash = "sha256-c8NBAN53NyF9dPB7txqYtM0ac0Y+Ch06fMA1LrIUkbc=";
    };

    meta = {
      description = "Supplementary data for deid package";
      homepage = "https://github.com/pydicom/deid-data";
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.bcdarwin ];
    };
  };
in
buildPythonPackage rec {
  pname = "deid";
<<<<<<< HEAD
  version = "0.3.22";
=======
  version = "0.3.21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";
  disabled = pythonOlder "3.7";

  # Pypi version has no tests
  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    # the github repo does not contain Pypi version tags:
<<<<<<< HEAD
    rev = "40dc96125daeb65856d643e12c3d6dfec756be0d";
    hash = "sha256-OtxQPF29eqt8I1Q12ga8a1IjBVO+VBk6y0DQmRtCNoU=";
=======
    rev = "38717b8cbfd69566ba489dd0c9858bb93101e26d";
    hash = "sha256-QqofxNjshbNfu8vZ37rB6pxj5R8q0wlUhJRhrpkKySk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    matplotlib
    pydicom
    python-dateutil
  ];

  nativeCheckInputs = [
    deid-data
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "deid"
  ];

  meta = with lib; {
    description = "Best-effort anonymization for medical images";
    homepage = "https://pydicom.github.io/deid";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
