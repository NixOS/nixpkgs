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
  stestrCheckHook,
  testtools,
  testscenarios,
  tempest,
}:

buildPythonPackage rec {
  pname = "python-neutronclient";
  version = "11.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-neutronclient";
    tag = version;
    hash = "sha256-wf+ZTLaBEzQPRVQOZ6JaqH88ymgGIgtRKKdJi2UvKdM=";
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
    stestrCheckHook
    testtools
    testscenarios
    tempest
  ];

  pythonImportsCheck = [ "neutronclient" ];

  meta = {
    description = "Python bindings for the OpenStack Networking API";
    homepage = "https://github.com/openstack/python-neutronclient/";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
