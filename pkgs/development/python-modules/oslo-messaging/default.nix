{ lib, fetchPypi, buildPythonPackage
# buildInputs
, futures
, oslo-middleware
, tenacity
, pika-pool
, pika
, kombu
, amqp
, pyyaml
, webob
, cachetools
, six
, monotonic
, debtcollector
, stevedore
, oslo-i18n
, oslo-service
, oslo-serialization
, oslo-utils
, oslo-log
, oslo-config
, futurist
, pbr
, jinja2
# checkInputs
, oslotest
, mock
, mox3
, subunit
, testtools
, testscenarios
, testrepository
, fixtures
, oslosphinx
}:

buildPythonPackage rec {
  pname = "oslo.messaging";
  version = "5.34.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jd96g5zic6dr67rlnqhf0ngcbi0jxc3qgbdfxarnh1k6w8qb9f5";
  };

  propagatedBuildInputs = [
    futures
    oslo-middleware
    tenacity
    pika-pool
    pika
    kombu
    amqp
    pyyaml
    webob
    cachetools
    six
    monotonic
    debtcollector
    stevedore
    oslo-i18n
    oslo-service
    oslo-serialization
    oslo-utils
    oslo-log
    oslo-config
    futurist
    pbr
    jinja2
  ];

  # socket.getprotobyname('tcp') due to greenlet
  doCheck = false;

  checkInputs = [
    oslotest
    mock
    mox3
    subunit
    testtools
    testscenarios
    testrepository
    fixtures
    oslosphinx
  ];

  meta = with lib; {
    description = "Oslo Messaging API";
    homepage = "https://docs.openstack.org/oslo.messaging/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
