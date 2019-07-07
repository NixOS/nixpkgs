{ stdenv, buildPythonPackage, fetchPypi
, pytest, tox, py, eventlet }:

buildPythonPackage rec {
  pname = "detox";
  version = "0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e650f95f0c7f5858578014b3b193e5dac76c89285c1bbe4bae598fd641bf9cd3";
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
    license = licenses.mit;
    # detox is unmaintained and incompatible with tox > 3.6
    broken = true;
  };
}
