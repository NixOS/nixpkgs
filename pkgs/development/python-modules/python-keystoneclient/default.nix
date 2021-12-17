{ lib
, buildPythonPackage
, fetchPypi
, keystoneauth1
, openssl
, oslo-config
, oslo-serialization
, pbr
, requests-mock
, stestr
, testresources
, testscenarios
}:

buildPythonPackage rec {
  pname = "python-keystoneclient";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd09b7790ce53c20dc94318ec4d76e1cf71908aed59baeb4c7a61c17afd3aad5";
  };

  propagatedBuildInputs = [
    keystoneauth1
    oslo-config
    oslo-serialization
    pbr
  ];

  checkInputs = [
    openssl
    requests-mock
    stestr
    testresources
    testscenarios
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "keystoneclient" ];

  meta = with lib; {
    description = "Client Library for OpenStack Identity";
    homepage = "https://github.com/openstack/python-keystoneclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
