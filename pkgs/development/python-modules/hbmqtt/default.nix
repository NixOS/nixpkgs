{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, transitions, websockets, passlib, docopt, pyyaml, nose }:

buildPythonPackage rec {
  pname = "hbmqtt";
  version = "0.9.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f61e05007648a4f33e300fafcf42776ca95508ba1141799f94169427ce5018c";
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
