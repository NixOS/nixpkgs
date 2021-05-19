{ stdenv
, lib
, fetchurl
, buildPythonPackage
, isPy27
, boost
, cmake
, mpi4py
, pybind11
, dijitso
, numpy
, sympy
, ufl
, pkgconfig
, ffc
, dolfin
}:

buildPythonPackage rec {
  pname = "fenics";
  inherit (dolfin) version;

  inherit (dolfin) src;
  sourceRoot = "source/python";

  nativeBuildInputs = [
    pybind11
    cmake
  ];

  dontUseCmakeConfigure = true;
  preConfigure = ''
    substituteInPlace setup.py --replace "pybind11==2.2.4" "pybind11"
    substituteInPlace dolfin/jit/jit.py \
      --replace 'pkgconfig.exists("dolfin")' 'pkgconfig.exists("${dolfin}/lib/pkgconfig/dolfin.pc")' \
      --replace 'pkgconfig.parse("dolfin")' 'pkgconfig.parse("${dolfin}/lib/pkgconfig/dolfin.pc")'
  '';

  buildInputs = [
    dolfin
    boost
  ];

  propagatedBuildInputs = [
    dijitso
    ffc
    mpi4py
    numpy
    ufl
    pkgconfig
    pybind11
  ];

  doCheck = false; # Tries to orte_ess_init and call ssh to localhost

  meta = with lib; {
    description = "Python bindings for the DOLFIN FEM compiler";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
