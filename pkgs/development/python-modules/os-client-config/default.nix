{
  lib,
  buildPythonPackage,
  fetchpatch,
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

  patches = [
    # Fix compatibility with openstacksdk 4.5.0
    (fetchpatch {
      url = "https://github.com/openstack/os-client-config/commit/46bc2deb4c6762dc1dd674686283eb3fa4c1d5e6.patch";
      hash = "sha256-wZdwCbgrRg0mxs542zjWAlXn0PzCotlbZaEyinYKwb4=";
    })
  ];

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
    description = "Unified config handling for client libraries and programs";
    homepage = "https://github.com/openstack/os-client-config";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
