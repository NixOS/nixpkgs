{ lib, stdenv
, buildPythonPackage
, pythonAtLeast
, fetchPypi
, mock
, pytest
, pytest-mock
, pytz
, requests
, requests-kerberos
, toml
}:

buildPythonPackage rec {
  pname = "jenkinsapi";
  version = "0.3.11";
  format = "setuptools";

  disabled = pythonAtLeast "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a212a244b0a6022a61657746c8120ac9b6db83432371b345154075eb8faceb61";
  };

  propagatedBuildInputs = [ pytz requests ];
  checkInputs = [ mock pytest pytest-mock requests-kerberos toml ];
  # TODO requests-kerberos is broken on darwin, weeding out the broken tests without
  # access to macOS is not an adventure I am ready to embark on - @rski
  doCheck = !stdenv.isDarwin;
  # don't run tests that try to spin up jenkins, and a few more that are mysteriously broken
  checkPhase = ''
    py.test jenkinsapi_tests \
      -k "not systests and not test_plugins and not test_view"
  '';

  meta = with lib; {
    description = "A Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = "https://github.com/salimfadhley/jenkinsapi";
    maintainers = with maintainers; [ drets ];
    license = licenses.mit;
  };

}
