{ lib, fetchPypi, buildPythonPackage
, webob
, oslo-utils
, oslo-service
, oslo-serialization
, oslo-policy
, oslo-messaging
, oslo-log
, oslo-i18n
, oslo-db
, oslo-context
, oslo-config
, oslo-concurrency
, stevedore
, debtcollector
, sqlalchemy
, pbr
}:

buildPythonPackage rec {
  pname = "neutron-lib";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r4f5hpbhickggmy5m1i7q0hcpzjz2bj5cj351g74jghyj21rp0f";
  };

  propagatedBuildInputs = [
    webob
    oslo-utils
    oslo-service
    oslo-serialization
    oslo-policy
    oslo-messaging
    oslo-log
    oslo-i18n
    oslo-db
    oslo-context
    oslo-config
    oslo-concurrency
    stevedore
    debtcollector
    sqlalchemy
    pbr
  ];

  checkInputs = [
    
  ];

  meta = with lib; {
    description = "Neutron shared routines and utilities";
    homepage = "https://docs.openstack.org/neutron-lib/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
