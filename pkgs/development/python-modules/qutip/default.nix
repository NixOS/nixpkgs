{ lib
, stdenv
, buildPythonPackage
, cvxopt
, cvxpy
, cython
<<<<<<< HEAD
=======
, doCheck ? true
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, ipython
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
<<<<<<< HEAD
  version = "4.7.3";
=======
  version = "4.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-cpzUHjZBpAbNEnYRuY1wUZouAEAgBaN9rWdxRSfI3bs=";
=======
    hash = "sha256-W5iqRWAB6D1Dnxz0Iyl7ZmP3yrXvLyV7BdBdIgFCiQY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-rerunfailures
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  # Disabling OpenMP support on Darwin.
  setupPyGlobalFlags = lib.optionals (!stdenv.isDarwin) [
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
    ipython = [
      ipython
    ];
    semidefinite = [
      cvxpy
      cvxopt
    ];
  };

  meta = with lib; {
<<<<<<< HEAD
    description = "Open-source software for simulating the dynamics of closed and open quantum systems";
    homepage = "https://qutip.org/";
    changelog = "https://github.com/qutip/qutip/releases/tag/v${version}";
=======
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Open-source software for simulating the dynamics of closed and open quantum systems";
    homepage = "https://qutip.org/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ fabiangd ];
  };
}
