{ stdenv, buildPythonPackage, fetchPypi
, pytestpep8, pytest, pyflakes }:

buildPythonPackage rec {
  pname = "pytest-flakes";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "341964bf5760ebbdde9619f68a17d5632c674c3f6903ef66daa0a4f540b3d143";
  };

  checkInputs = [ pytestpep8 pytest ];
  nativeBuildInputs = [ pytest ];
  propagatedBuildInputs = [ pyflakes ];

  # disable one test case that looks broken
  checkPhase = ''
    py.test test_flakes.py -k 'not test_syntax_error'
  '';

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = https://pypi.python.org/pypi/pytest-flakes;
    description = "pytest plugin to check source code with pyflakes";
  };
}
