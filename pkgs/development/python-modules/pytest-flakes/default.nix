{ stdenv, buildPythonPackage, fetchPypi
, pytestpep8, pytest, pyflakes, pytestcache }:

buildPythonPackage rec {
  pname = "pytest-flakes";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e880927fd2a77d31715eaab3876196e76d779726c9c24fe32ee5bab23281f82";
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
