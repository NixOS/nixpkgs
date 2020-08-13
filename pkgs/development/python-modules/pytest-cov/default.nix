{ stdenv, buildPythonPackage, fetchPypi
, pytest, coverage }:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "2.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6a814b8ed6247bd81ff47f038511b57fe1ce7f4cc25b9106f1a4b106f1d9322";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ coverage ];

  # xdist related tests fail with the following error
  # OSError: [Errno 13] Permission denied: 'py/_code'
  doCheck = false;
  checkPhase = ''
    # allow to find the module helper during the test run
    export PYTHONPATH=$PYTHONPATH:$PWD/tests
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Plugin for coverage reporting with support for both centralised and distributed testing, including subprocesses and multiprocessing";
    homepage = "https://github.com/pytest-dev/pytest-cov";
    license = licenses.mit;
  };
}
