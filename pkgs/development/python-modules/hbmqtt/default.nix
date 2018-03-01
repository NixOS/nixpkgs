{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, transitions, websockets, passlib, docopt, pyyaml, nose }:

buildPythonPackage rec {
  pname = "hbmqtt";
  version = "0.9.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04lqqcy84f9gcwqhrlvzp689r3mkdd8ipsnfzw8gryfny4lh8wrx";
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
