{ stdenv, buildPythonPackage, fetchPypi
, pytest, cmdline, pytestcov, coverage, setuptools-git, mock, pathpy, execnet
, contextlib2 }:

buildPythonPackage rec {
  pname = "pytest-shutil";
  version = "1.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gdzarg3l7d80lj0gh9bcsw9r12gmf306n4y2cb18y7kqfpcqjlj";
  };

  buildInputs = [ cmdline pytest ];
  propagatedBuildInputs = [ pytestcov coverage setuptools-git mock pathpy execnet contextlib2 ];

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
