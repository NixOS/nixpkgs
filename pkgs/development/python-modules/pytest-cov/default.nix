{ lib
, buildPythonPackage
, fetchPypi
, pytest
, coverage
, toml
, tomli
}:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7f0f5b1617d2210a2cabc266dfe2f4c75a8d32fb89eafb7ad9d06f6d076d470";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ coverage toml tomli ];

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
    license = licenses.mit;
  };
}
