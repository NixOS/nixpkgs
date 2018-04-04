{ stdenv, buildPythonPackage, fetchPypi
, pytest, tox, py, eventlet }:

buildPythonPackage rec {
  pname = "detox";
  version = "0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4719ca48c4ea5ffd908b1bc3d5d1b593b41e71dee17180d58d8a3e7e8f588d45";
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
