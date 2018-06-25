{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, isPy3k
, transitions, websockets, passlib, docopt, pyyaml, nose }:

buildPythonPackage rec {
  pname = "hbmqtt";
  version = "0.9.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f61e05007648a4f33e300fafcf42776ca95508ba1141799f94169427ce5018c";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/beerfactory/hbmqtt/commit/75a85d1ea4cb41f2a15f2681d3114da7158942ae.patch";
      sha256 = "0bl4v5zxp4kz2w7riwrx48f7yqmp7pxg79g9qavkda0i85lxswnp";
    })
  ];

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
