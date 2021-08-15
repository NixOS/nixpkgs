{ lib, buildPythonPackage, fetchPypi
, pbr, debtcollector, keystoneauth1, oslo-config, oslo-serialization, oslo-utils, requests, six, stevedore
, stestr, testresources, testscenarios, requests-mock, openssl }:

buildPythonPackage rec {
  pname = "python-keystoneclient";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12jsiw82x2zcn8sf78xisf85kr28gl3jqj46a0wxx59v91p44j02";
  };

  propagatedBuildInputs = [
    pbr
    debtcollector
    keystoneauth1
    oslo-config
    oslo-serialization
    oslo-utils
    requests
    six
    stevedore
  ];

  checkInputs = [ stestr testresources testscenarios requests-mock openssl ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "keystoneclient" ];

  meta = with lib; {
    description = "Client Library for OpenStack Identity";
    homepage = "https://docs.openstack.org/python-keystoneclient/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
