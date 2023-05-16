{ lib
, buildPythonPackage
, numpy
, scipy
, pyamg
, future
, matplotlib
, tkinter
, mpi4py
, scikit-fmm
, gmsh
, python
, stdenv
, openssh
, fetchFromGitHub
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "fipy";
<<<<<<< HEAD
  version = "3.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "3.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "fipy";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-XZpm+gzysR2OXBcxWUEjP1PlaLuOL2NpmeKMCH+OEb4=";
=======
    rev = version;
    hash = "sha256-oTg/5fGXqknWBh1ShdAOdOwX7lVDieIoM5aALcOWFqY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    numpy
    scipy
    pyamg
    matplotlib
    tkinter
    mpi4py
    future
    scikit-fmm
    openssh
<<<<<<< HEAD
  ] ++ lib.optionals (!stdenv.isDarwin) [
    gmsh
  ];

  nativeCheckInputs = lib.optionals (!stdenv.isDarwin) [
    gmsh
  ];
=======
  ] ++ lib.optionals (!stdenv.isDarwin) [ gmsh ];

  nativeCheckInputs = lib.optionals (!stdenv.isDarwin) [ gmsh ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  checkPhase = ''
    export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
    ${python.interpreter} setup.py test --modules
  '';

<<<<<<< HEAD
  pythonImportsCheck = [
    "fipy"
  ];
=======
  pythonImportsCheck = [ "fipy" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://www.ctcms.nist.gov/fipy/";
    description = "A Finite Volume PDE Solver Using Python";
<<<<<<< HEAD
    changelog = "https://github.com/usnistgov/fipy/blob/${version}/CHANGELOG.rst";
    license = licenses.free;
    maintainers = with maintainers; [ wd15 ];
=======
    license = licenses.free;
    maintainers = with maintainers; [ costrouc wd15 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
