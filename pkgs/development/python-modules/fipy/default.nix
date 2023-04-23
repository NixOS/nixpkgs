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
}:

buildPythonPackage rec {
  pname = "fipy";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "fipy";
    rev = version;
    hash = "sha256-oTg/5fGXqknWBh1ShdAOdOwX7lVDieIoM5aALcOWFqY=";
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
  ] ++ lib.optionals (!stdenv.isDarwin) [ gmsh ];

  nativeCheckInputs = lib.optionals (!stdenv.isDarwin) [ gmsh ];

  checkPhase = ''
    export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
    ${python.interpreter} setup.py test --modules
  '';

  pythonImportsCheck = [ "fipy" ];

  meta = with lib; {
    homepage = "https://www.ctcms.nist.gov/fipy/";
    description = "A Finite Volume PDE Solver Using Python";
    license = licenses.free;
    maintainers = with maintainers; [ costrouc wd15 ];
  };
}
