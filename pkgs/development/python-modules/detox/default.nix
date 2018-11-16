{ stdenv, buildPythonPackage, fetchPypi
, pytest, tox, py, eventlet }:

buildPythonPackage rec {
  pname = "detox";
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0c2af9c29f8e200a50b561ccc531df3087c80e7d3de6cfa9828f5fea3c8f56c";
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
