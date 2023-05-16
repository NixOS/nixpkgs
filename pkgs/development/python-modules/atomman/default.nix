{ lib
, ase
, buildPythonPackage
, cython
, datamodeldict
, fetchFromGitHub
, matplotlib
, numericalunits
, numpy
, pandas
, phonopy
, potentials
, pymatgen
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
=======
, pytest
, pytestCheckHook
, pythonOlder
, pythonAtLeast
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
, scipy
, setuptools
, toolz
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, xmltodict
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
<<<<<<< HEAD
  version = "unstable-2023-07-28";
=======
  version = "1.4.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "atomman";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "atomman";
<<<<<<< HEAD
    rev = "b8af21a9285959d38ee26173081db1b4488401bc";
    hash = "sha256-WfB+OY61IPprT6OCVHl8VA60p7lLVkRGuyYX+nm7bbA=";
=======
    rev = "v${version}";
    hash = "sha256-tcsxtFbBdMC6+ixzqhnR+5UNwcQmnPQSvuyNA2IYelI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    cython
    datamodeldict
    matplotlib
    numericalunits
    numpy
    pandas
    potentials
    requests
    scipy
    toolz
    xmltodict
  ];

  pythonRelaxDeps = [ "potentials" ];

  preCheck = ''
    # By default, pytestCheckHook imports atomman from the current directory
    # instead of from where `pip` installs it and fails due to missing Cython
    # modules. Fix this by removing atomman from the current directory.
    #
    rm -r atomman
  '';

  nativeCheckInputs = [
    ase
    phonopy
    pymatgen
<<<<<<< HEAD
=======
    pytest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  disabledTests = [
    "test_unique_shifts_prototype" # needs network access to download database files
  ];

  pythonImportsCheck = [
    "atomman"
  ];

  meta = with lib; {
    description = "Atomistic Manipulation Toolkit";
    homepage = "https://github.com/usnistgov/atomman/";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
