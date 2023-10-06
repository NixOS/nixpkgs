{ lib
, buildPythonPackage
, fetchPypi
, keystoneauth1
, openssl
, oslo-config
, oslo-serialization
, pbr
, pythonOlder
, requests-mock
, stestr
, testresources
, testscenarios
}:

buildPythonPackage rec {
  pname = "python-keystoneclient";
  version = "5.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cqQsOGniEouwxiashWw9vz447xbX6F3TVWe4LNJFOak=";
  };

  propagatedBuildInputs = [
    keystoneauth1
    oslo-config
    oslo-serialization
    pbr
  ];

  nativeCheckInputs = [
    openssl
    requests-mock
    stestr
    testresources
    testscenarios
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [
    "keystoneclient"
  ];

  meta = with lib; {
    description = "Client Library for OpenStack Identity";
    homepage = "https://github.com/openstack/python-keystoneclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
