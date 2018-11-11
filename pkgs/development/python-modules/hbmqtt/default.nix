{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, isPy3k
, transitions, websockets, passlib, docopt, pyyaml, nose }:

buildPythonPackage rec {
  pname = "hbmqtt";
  version = "0.9.5";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9886b1c8321d16e971376dc609b902e0c84118846642b5e09f08a4ca876a7f2a";
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
