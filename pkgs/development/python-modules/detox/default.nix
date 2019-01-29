{ stdenv, buildPythonPackage, fetchPypi
, pytest, tox, py, eventlet }:

buildPythonPackage rec {
  pname = "detox";
  version = "0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yvfhnkw6zpm11yrl2shl794yi68jcfqj8m5n596gqxxbiq6gp90";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ tox py eventlet ];

  checkPhase = ''
    py.test
  '';

  # eventlet timeout, and broken invokation 3.5
  doCheck = false;

  meta = with stdenv.lib; {
    description = "What is detox?";
    homepage = https://bitbucket.org/hpk42/detox;
  };
}
