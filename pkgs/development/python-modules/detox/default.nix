{ stdenv, buildPythonPackage, fetchPypi
, pytest, tox, py, eventlet }:

buildPythonPackage rec {
  pname = "detox";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "accde1a79b621df9dfd55b97460e80743a771a3d9a1acd900489a4355f0cc8c7";
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
