{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sybil,
  pytest,
  pytestCheckHook,
  mpi,
  mpi4py,
}:

buildPythonPackage rec {
  pname = "pytest-mpi";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aragilar";
    repo = "pytest-mpi";
    rev = "v${version}";
    hash = "sha256-m3HTGLoPnYeg0oeIA1nzTzch7FtkuXTYpox4rRgo5MU=";
  };

  build-system = [
    setuptools
  ];
  buildInputs = [
    # Don't propagate it to let a different pytest version be used if needed
    pytest
  ];
  dependencies = [
    sybil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mpi
    mpi4py
  ];
  # Tests cause the Python interpreter to crash from some reason, a hard issue
  # to debug. (TODO: discuss this with upstream)
  doCheck = false;
  pytestFlagsArray = [
    # https://github.com/aragilar/pytest-mpi/issues/4#issuecomment-634614337
    "-p"
    "pytester"
  ];

  pythonImportsCheck = [ "pytest_mpi" ];

  meta = {
    description = "Pytest plugin for working with MPI";
    homepage = "https://github.com/aragilar/pytest-mpi";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
