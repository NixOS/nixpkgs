{
  lib,
  buildPythonPackage,
  fetchPypi,
  fixtures,
  hacking,
  jsonschema,
  openstacksdk,
  oslotest,
  python-glanceclient,
  setuptools,
  stestr,
  subunit,
  testscenarios,
  testtools,
}:

buildPythonPackage rec {
  pname = "os-client-config";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q8OKNR+MAG009+5fP2SN5ePs9kVcxdds/YidKRzfP04=";
  };

  build-system = [ setuptools ];

  dependencies = [
    openstacksdk
    python-glanceclient
  ];

  nativeCheckInputs = [
    hacking
    fixtures
    jsonschema
    subunit
    oslotest
    stestr
    testscenarios
    testtools
  ];

  checkPhase = ''
    runHook preCheck

    stestr run

    runHook postCheck
  '';

  pythonImportsCheck = [ "os_client_config" ];

  meta = with lib; {
    homepage = "https://opendev.org/openstack/os-client-config";
    description = "Collect client configuration for using OpenStack in consistent and comprehensive manner";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
