{ lib
, buildPythonPackage
, numpy
, scipy
, pyamg
, pysparse
, future
, matplotlib
, tkinter
, mpi4py
, scikit-fmm
, isPy27
, gmsh
, python
, stdenv
, openssh
, fetchurl
}:

buildPythonPackage rec {
  pname = "fipy";
  version = "3.4.2.1";

  src = fetchurl {
    url = "https://github.com/usnistgov/fipy/releases/download/${version}/FiPy-${version}.tar.gz";
    sha256 = "0v5yk9b4hksy3176w4vm4gagb9kxqgv75zcyswlqvl371qwy1grk";
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
  ] ++ lib.optionals isPy27 [ pysparse ]
  ++ lib.optionals (!stdenv.isDarwin) [ gmsh ];

  # Reading version string from Gmsh is broken in latest release of FiPy
  # This issue is repaired on master branch of FiPy
  # Fixed with: https://github.com/usnistgov/fipy/pull/848/files
  # Remove patch with next release.
  patches = [ ./gmsh.patch ];

  checkInputs = lib.optionals (!stdenv.isDarwin) [ gmsh ];

  checkPhase = ''
    export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
    ${python.interpreter} setup.py test --modules
  '';

  meta = with lib; {
    homepage = "https://www.ctcms.nist.gov/fipy/";
    description = "A Finite Volume PDE Solver Using Python";
    license = licenses.free;
    maintainers = with maintainers; [ costrouc wd15 ];
  };
}
