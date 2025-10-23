{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # Build and Runtime
  pbr,
  cliff,
  debtcollector,
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
  requests-mock,
  stestr,
  testtools,
  testscenarios,
  tempest,
}:

buildPythonPackage rec {
  pname = "python-neutronclient";
  version = "11.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-neutronclient";
    tag = version;
    hash = "sha256-nz7KiFe8IWJypGCjFgrEgGTEsC0xlW3YG/QRNJUzcpc=";
  };

  env.PBR_VERSION = version;

  build-system = [
    setuptools
    pbr
  ];

  dependencies = [
    cliff
    debtcollector
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
    homepage = "https://github.com/openstack/python-neutronclient/";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
