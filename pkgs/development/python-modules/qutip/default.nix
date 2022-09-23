{ lib
, stdenv
, buildPythonPackage
, cvxopt
, cvxpy
, cython
, doCheck ? true
, fetchFromGitHub
, matplotlib
, numpy
, packaging
, pytest-rerunfailures
, pytestCheckHook
, python
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "qutip";
  version = "4.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wGr6uTM6pFL2nvN4zdqPdEO8O3kjrRtKWx8luL1t9Sw=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    scipy
  ];

  checkInputs = [
    pytestCheckHook
    pytest-rerunfailures
  ] ++ passthru.optional-dependencies.graphics;

  # Disabling OpenMP support on Darwin.
  setupPyGlobalFlags = lib.optional (!stdenv.isDarwin) [
    "--with-openmp"
  ];

  # QuTiP tries to access the home directory to create an rc file for us.
  # We need to go to another directory to run the tests from there.
  # This is due to the Cython-compiled modules not being in the correct location
  # of the source tree.
  preCheck = ''
    export HOME=$(mktemp -d);
    export OMP_NUM_THREADS=$NIX_BUILD_CORES
    mkdir -p test && cd test
  '';

  # For running tests, see https://qutip.org/docs/latest/installation.html#verifying-the-installation
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -c "import qutip.testing; qutip.testing.run()"
    runHook postCheck
  '';

  pythonImportsCheck = [
    "qutip"
  ];

  passthru.optional-dependencies = {
    graphics = [
      matplotlib
    ];
    semidefinite = [
      cvxpy
      cvxopt
    ];
  };

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Open-source software for simulating the dynamics of closed and open quantum systems";
    homepage = "https://qutip.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fabiangd ];
  };
}
