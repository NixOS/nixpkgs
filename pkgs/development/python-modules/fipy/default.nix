{ lib
, buildPythonPackage
, fetchPypi
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
}:

buildPythonPackage rec {
  pname = "fipy";
  version = "3.3";

  src = fetchPypi {
    pname = "FiPy";
    inherit version;
    sha256 = "11agpg3d6yrns8igkpml1mxy3mkqkjq2yrw1mw12y07dkk12ii19";
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
  ] ++ lib.optionals isPy27 [ pysparse ];

  meta = with lib; {
    homepage = https://www.ctcms.nist.gov/fipy/;
    description = "A Finite Volume PDE Solver Using Python";
    license = licenses.free;
    maintainers = with maintainers; [ costrouc ];
  };
}
