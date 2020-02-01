{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, transitions, websockets, passlib, docopt, pyyaml, nose }:

buildPythonPackage rec {
  pname = "hbmqtt";
  version = "0.9.6";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n9c8yj11npiq9qxivwmfhib1qkjpcyw42a7q0w641bdrz3x6r37";
  };

  propagatedBuildInputs = [ transitions websockets passlib docopt pyyaml ];

  postPatch = ''
    # test tries to bind same port multiple times and fails
    rm tests/test_client.py
  '';

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
