{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pytest,
}:

buildPythonPackage rec {
  version = "3.1.2";
  pname = "python-gflags";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40ae131e899ef68e9e14aa53ca063839c34f6a168afe622217b5b875492a1ee2";
  };

  nativeCheckInputs = [ pytest ];

  propagatedBuildInputs = [ six ];

  checkPhase = ''
    # clashes with our pythhon wrapper (which is in argv0)
    # AssertionError: 'gflags._helpers_test' != 'nix_run_setup.py'
    py.test -k 'not testGetCallingModule'
  '';

  meta = {
    homepage = "https://github.com/google/python-gflags";
    description = "A module for command line handling, similar to Google's gflags for C++";
    license = lib.licenses.bsd3;
  };
}
