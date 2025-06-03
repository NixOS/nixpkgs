{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  coverage,
  setuptools,
  toml,
  tomli,
}:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "6.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_cov";
    inherit version;
    hash = "sha256-7FXoKMZnVeW3SiG9fMA8MDqfkoOJwFY+ULpFSm2+cds=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [
    coverage
    toml
    tomli
  ];

  # xdist related tests fail with the following error
  # OSError: [Errno 13] Permission denied: 'py/_code'
  doCheck = false;
  checkPhase = ''
    # allow to find the module helper during the test run
    export PYTHONPATH=$PYTHONPATH:$PWD/tests
    py.test tests
  '';

  pythonImportsCheck = [ "pytest_cov" ];

  meta = with lib; {
    description = "Plugin for coverage reporting with support for both centralised and distributed testing, including subprocesses and multiprocessing";
    homepage = "https://github.com/pytest-dev/pytest-cov";
    changelog = "https://github.com/pytest-dev/pytest-cov/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
