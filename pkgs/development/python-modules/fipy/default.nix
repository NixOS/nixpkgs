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
, gmsh
, python
, stdenv
, openssh
, fetchurl
}:

let
  not_darwin_inputs = lib.optionals (! stdenv.isDarwin) [ gmsh ];
in
  buildPythonPackage rec {
    pname = "fipy";
    version = "3.4.1";

    src = fetchurl {
      url = "https://github.com/usnistgov/fipy/releases/download/${version}/FiPy-${version}.tar.gz";
      sha256 = "0078yg96fknqhywn1v26ryc5z47c0j0c1qwz6p8wsjn0wmzggaqk";
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
    ] ++ lib.optionals isPy27 [ pysparse ] ++ not_darwin_inputs;

    checkInputs = not_darwin_inputs;

    checkPhase = ''
      export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
      ${python.interpreter} setup.py test --modules
    '';

    meta = with lib; {
      homepage = https://www.ctcms.nist.gov/fipy/;
      description = "A Finite Volume PDE Solver Using Python";
      license = licenses.free;
      maintainers = with maintainers; [ costrouc wd15 ];
    };
  }
