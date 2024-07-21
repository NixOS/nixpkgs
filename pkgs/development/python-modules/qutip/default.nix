{
  lib,
  buildPythonPackage,
  cvxopt,
  cvxpy,
  cython_0,
  fetchFromGitHub,
  ipython,
  matplotlib,
  numpy,
  oldest-supported-numpy,
  packaging,
  pytest-rerunfailures,
  pytestCheckHook,
  python,
  pythonOlder,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "qutip";
  version = "5.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-lMPzgmUaoEQB5TzmqEJFiFTuS3AGpyMMjPHlPUKTLvk=";
  };

  nativeBuildInputs = [
    cython_0
    setuptools
    oldest-supported-numpy
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

  pythonImportsCheck = [ "qutip" ];

  passthru.optional-dependencies = {
    graphics = [ matplotlib ];
    ipython = [ ipython ];
    semidefinite = [
      cvxpy
      cvxopt
    ];
  };

  meta = with lib; {
    description = "Open-source software for simulating the dynamics of closed and open quantum systems";
    homepage = "https://qutip.org/";
    changelog = "https://github.com/qutip/qutip/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fabiangd ];
  };
}
