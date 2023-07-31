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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fipy";
  version = "3.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "fipy";
    rev = "refs/tags/${version}";
    hash = "sha256-XZpm+gzysR2OXBcxWUEjP1PlaLuOL2NpmeKMCH+OEb4=";
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
  ] ++ lib.optionals (!stdenv.isDarwin) [
    gmsh
  ];

  nativeCheckInputs = lib.optionals (!stdenv.isDarwin) [
    gmsh
  ];

  checkPhase = ''
    export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
    ${python.interpreter} setup.py test --modules
  '';

  pythonImportsCheck = [
    "fipy"
  ];

  meta = with lib; {
    homepage = "https://www.ctcms.nist.gov/fipy/";
    description = "A Finite Volume PDE Solver Using Python";
    changelog = "https://github.com/usnistgov/fipy/blob/${version}/CHANGELOG.rst";
    license = licenses.free;
    maintainers = with maintainers; [ wd15 ];
  };
}
