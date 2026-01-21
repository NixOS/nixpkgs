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
  stestr,
  testtools,
  testscenarios,
  tempest,
}:

buildPythonPackage rec {
  pname = "python-neutronclient";
  version = "11.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-neutronclient";
    tag = version;
    hash = "sha256-nkKADTdqYaPMmQU8Fulc8rE5lmMwPjFonyvMNOBvulA=";
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

  meta = {
    description = "Python bindings for the OpenStack Networking API";
    homepage = "https://github.com/openstack/python-neutronclient/";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
