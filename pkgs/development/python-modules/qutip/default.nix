{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, matplotlib
, cython
, nose
, isPy27
}:

buildPythonPackage rec {
  pname = "qutip";
  version = "4.4.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "qutip";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aa61q70hg3wk3k67zg4m095isclw49dlfl8kbakv0w698nhiazc";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
  ];

  checkInputs = [
    nose
  ];

  checkPhase = ''
    pushd dist
    HOME=$TMPDIR nosetests qutip
    popd
  '';

  meta = with lib; {
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
