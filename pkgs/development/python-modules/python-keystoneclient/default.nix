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
  version = "4.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bX8FxpLn2yaSd4KEx3mubOqLIVmRS0QXpfoL/qHinNw=";
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
