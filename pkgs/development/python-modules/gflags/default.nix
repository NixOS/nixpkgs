{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  version = "3.1.1";
  name = "gflags-${version}";

  src = fetchPypi {
    inherit version;
    pname = "python-gflags";
    sha256 = "0qvcizlz6r4511kl4jlg6fr34y1ka956dr2jj1q0qcklr94n9zxa";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ six ];

  checkPhase = ''
    # clashes with our pythhon wrapper (which is in argv0)
    # AssertionError: 'gflags._helpers_test' != 'nix_run_setup.py'
    py.test -k 'not testGetCallingModule'
  '';

  meta = {
    homepage = https://github.com/google/python-gflags;
    description = "A module for command line handling, similar to Google's gflags for C++";
    license = lib.licenses.bsd3;
  };
}
