{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  coverage,
  hatchling,
  hatch-fancy-pypi-readme,
  toml,
  tomli,
}:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "7.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_cov";
    inherit version;
    hash = "sha256-M8l+2i4EmgxSmOkfUZMCoTNMJqxlwaSD1iBv1Fg2GvE=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

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

  meta = {
    description = "Plugin for coverage reporting with support for both centralised and distributed testing, including subprocesses and multiprocessing";
    homepage = "https://github.com/pytest-dev/pytest-cov";
    changelog = "https://github.com/pytest-dev/pytest-cov/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
