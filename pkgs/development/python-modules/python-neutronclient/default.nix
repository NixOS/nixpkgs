{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  # Build and Runtime
  pbr,
  cliff,
  debtcollector,
  iso8601,
  netaddr,
  openstacksdk,
  osc-lib,
  oslo-i18n,
  oslo-log,
  oslo-serialization,
  oslo-utils,
  os-client-config,
  keystoneauth1,
  python-keystoneclient,
  requests,
  hacking,
  # Tests
  fixtures,
  oslotest,
  osprofiler,
  python-openstackclient,
  subunit,
  requests-mock,
  stestr,
  testtools,
  testscenarios,
  tempest,
}:

buildPythonPackage rec {
  pname = "python-neutronclient";
  version = "11.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U82ZI/Q6OwdypA41YfdGVa3IA4+QJhqz3gW2IR0S7cs=";
  };

  build-system = [
    setuptools
    pbr
  ];

  dependencies = [
    cliff
    debtcollector
    iso8601
    netaddr
    openstacksdk
    osc-lib
    oslo-i18n
    oslo-log
    oslo-serialization
    oslo-utils
    os-client-config
    keystoneauth1
    python-keystoneclient
    requests
  ];

  nativeCheckInputs = [
    hacking
    fixtures
    oslotest
    osprofiler
    python-openstackclient
    subunit
    requests-mock
    stestr
    testtools
    testscenarios
    tempest
  ];

  checkPhase = ''
    runHook preCheck

    stestr run

    runHook postCheck
  '';

  pythonImportsCheck = [ "neutronclient" ];

  meta = with lib; {
    description = "Python bindings for the OpenStack Networking API";
    homepage = "https://opendev.org/openstack/python-neutronclient/";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
