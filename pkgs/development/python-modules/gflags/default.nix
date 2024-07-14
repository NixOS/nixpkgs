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
    hash = "sha256-QK4THome9o6eFKpTygY4OcNPahaK/mIiF7W4dUkqHuI=";
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
    description = "Module for command line handling, similar to Google's gflags for C++";
    license = lib.licenses.bsd3;
  };
}
