{ stdenv, buildPythonPackage, fetchPypi
, pytestpep8, pytest, pyflakes, pytestcache }:

buildPythonPackage rec {
  pname = "pytest-flakes";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "763ec290b89e2dc8f25f49d71cb9b869b8df843697b730233f61c78f847f2e57";
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
