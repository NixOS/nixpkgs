{ stdenv, lib, isPyPy, buildPythonPackage, fetchPypi
, pytest, cmdline, pytestcov, coverage, setuptools-git, mock, pathpy, execnet
, contextlib2, termcolor }:

buildPythonPackage rec {
  pname = "pytest-shutil";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q8j0ayzmnvlraml6i977ybdq4xi096djhf30n2m1rvnvrhm45nq";
  };

  checkInputs = [ cmdline pytest ];
  propagatedBuildInputs = [ pytestcov coverage setuptools-git mock pathpy execnet contextlib2 termcolor ];
  nativeBuildInputs = [ pytest ];

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
