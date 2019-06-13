{ stdenv, lib, isPyPy, buildPythonPackage, fetchPypi
, pytest_3, cmdline, pytestcov, coverage, setuptools-git, mock, pathpy, execnet
, contextlib2, termcolor }:

buildPythonPackage rec {
  pname = "pytest-shutil";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efe615b7709637ec8828abebee7fc2ad033ae0f1fc54145f769a8b5e8cc3b4ca";
  };

  checkInputs = [ cmdline pytest_3 ];
  propagatedBuildInputs = [ pytestcov coverage setuptools-git mock pathpy execnet contextlib2 termcolor ];
  nativeBuildInputs = [ pytest_3 ];

  checkPhase = ''
    py.test ${lib.optionalString isPyPy "-k'not (test_run or test_run_integration)'"}
  '';

  meta = with stdenv.lib; {
    description = "A goodie-bag of unix shell and environment tools for py.test";
    homepage = https://github.com/manahl/pytest-plugins;
    maintainers = with maintainers; [ ryansydnor ];
    license = licenses.mit;
  };
}
