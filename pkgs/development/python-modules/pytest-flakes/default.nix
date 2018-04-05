{ stdenv, buildPythonPackage, fetchPypi
, pytestpep8, pytest, pyflakes, pytestcache }:

buildPythonPackage rec {
  pname = "pytest-flakes";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0flag3n33kbhyjrhzmq990rvg4yb8hhhl0i48q9hw0ll89jp28lw";
  };

  buildInputs = [ pytestpep8 pytest ];
  propagatedBuildInputs = [ pyflakes pytestcache ];

  checkPhase = ''
    py.test test_flakes.py
  '';

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = https://pypi.python.org/pypi/pytest-flakes;
    description = "pytest plugin to check source code with pyflakes";
  };
}
