{ lib, buildPythonPackage, fetchPypi, isPy3k, pythonAtLeast, setuptools
, transitions, websockets, passlib, docopt, pyyaml, nose }:

buildPythonPackage rec {
  pname = "hbmqtt";
  version = "0.9.6";

  # https://github.com/beerfactory/hbmqtt/issues/223
  disabled = !isPy3k || pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n9c8yj11npiq9qxivwmfhib1qkjpcyw42a7q0w641bdrz3x6r37";
  };

  propagatedBuildInputs = [
    transitions websockets passlib docopt pyyaml setuptools
  ];

  postPatch = ''
    # https://github.com/beerfactory/hbmqtt/pull/241
    substituteInPlace hbmqtt/adapters.py \
      --replace "websockets.protocol" "websockets.legacy.protocol"

    # test tries to bind same port multiple times and fails
    rm tests/test_client.py
  '';

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -e test_connect_tcp
  '';

  meta = with lib; {
    homepage = "https://github.com/beerfactory/hbmqtt";
    description = "MQTT client/broker using Python asynchronous I/O";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
