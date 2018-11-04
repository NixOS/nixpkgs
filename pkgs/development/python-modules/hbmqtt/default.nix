{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, isPy3k
, transitions, websockets, passlib, docopt, pyyaml, nose }:

buildPythonPackage rec {
  pname = "hbmqtt";
  version = "0.9.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "48f2f3ef2beb9924a4c2c10263630e65cf8d11f72c812748a0b2c1b09499602b";
  };

  propagatedBuildInputs = [ transitions websockets passlib docopt pyyaml ];

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -e test_connect_tcp
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/beerfactory/hbmqtt;
    description = "MQTT client/broker using Python asynchronous I/O";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
