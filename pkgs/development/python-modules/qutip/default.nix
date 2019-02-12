{ stdenv
, buildPythonPackage
, fetchurl
, numpy
, scipy
, matplotlib
, pyqt4
, cython
, pkgs
, nose
}:

buildPythonPackage rec {
  pname = "qutip";
  version = "2.2.0";

  src = fetchurl {
    url = "https://qutip.googlecode.com/files/QuTiP-${version}.tar.gz";
    sha256 = "a26a639d74b2754b3a1e329d91300e587e8c399d8a81d8f18a4a74c6d6f02ba3";
  };

  propagatedBuildInputs = [ numpy scipy matplotlib pyqt4 cython ];

  buildInputs = [ pkgs.gcc pkgs.qt4 pkgs.blas nose ];

  meta = with stdenv.lib; {
    description = "QuTiP - Quantum Toolbox in Python";
    longDescription = ''
      QuTiP is open-source software for simulating the dynamics of
      open quantum systems. The QuTiP library depends on the
      excellent Numpy and Scipy numerical packages. In addition,
      graphical output is provided by Matplotlib. QuTiP aims to
      provide user-friendly and efficient numerical simulations of a
      wide variety of Hamiltonians, including those with arbitrary
      time-dependence, commonly found in a wide range of physics
      applications such as quantum optics, trapped ions,
      superconducting circuits, and quantum nanomechanical
      resonators.
    '';
    homepage = http://qutip.org/;
    license = licenses.bsd0;
  };

}
