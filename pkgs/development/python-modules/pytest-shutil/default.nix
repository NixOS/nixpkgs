{ stdenv, buildPythonPackage, fetchPypi
, pytest, cmdline, pytestcov, coverage, setuptools-git, mock, pathpy, execnet
, contextlib2, termcolor }:

buildPythonPackage rec {
  pname = "pytest-shutil";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2cfe4d3f5f25ad2b19e64847d62563f5494b2e0450ca1cfc5940974029b2cbd1";
  };

  buildInputs = [ cmdline pytest ];
  propagatedBuildInputs = [ pytestcov coverage setuptools-git mock pathpy execnet contextlib2 termcolor ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A goodie-bag of unix shell and environment tools for py.test";
    homepage = https://github.com/manahl/pytest-plugins;
    maintainers = with maintainers; [ ryansydnor ];
    license = licenses.mit;
  };
}
