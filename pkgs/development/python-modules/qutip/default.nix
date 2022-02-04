{ lib, stdenv, fetchFromGitHub, buildPythonPackage, python, packaging, numpy
, cython, scipy, matplotlib, pytestCheckHook, pytest-rerunfailures }:

buildPythonPackage rec {
  pname = "qutip";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "04g7ixq1yrrid4lliqbcamnzyw5r0fjbl8ipklps234hvsjfwmxb";
  };

  # QuTiP says it needs specific (old) Numpy versions. We overwrite them here
  # as the tests work perfectly fine with up-to-date packages.
  postPatch = ''
    substituteInPlace setup.cfg --replace "numpy>=1.16.6,<1.20" "numpy>=1.16.6"
  '';

  # Disabling OpenMP support on Darwin.
  setupPyGlobalFlags = lib.optional (!stdenv.isDarwin) "--with-openmp";

  propagatedBuildInputs = [
    packaging
    numpy
    cython
    scipy
    matplotlib
  ];

  checkInputs = [
    pytestCheckHook
    pytest-rerunfailures
  ];

  # - QuTiP tries to access the home directory to create an rc file for us.
  # This of course fails and therefore, we provide a writable temp dir as HOME.
  # - We need to go to another directory to run the tests from there.
  # This is due to the Cython-compiled modules not being in the correct location
  # of the source tree.
  # - For running tests, see:
  # https://qutip.org/docs/latest/installation.html#verifying-the-installation
  checkPhase = ''
    export OMP_NUM_THREADS=$NIX_BUILD_CORES
    export HOME=$(mktemp -d)
    mkdir -p test && cd test
    ${python.interpreter} -c "import qutip.testing; qutip.testing.run()"
  '';

  meta = with lib; {
    description = "Open-source software for simulating the dynamics of closed and open quantum systems";
    homepage = "https://qutip.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.fabiangd ];
  };
}
