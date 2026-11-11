{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  openstacksdk,
  osc-lib,
  oslo-config,
  oslo-i18n,
  oslotest,
  pbr,
  prometheus-client,
  python-novaclient,
  python-openstackclient,
  requests-mock,
  setuptools,
  stestrCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "otcextensions";
  version = "0.34.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opentelekomcloud";
    repo = "python-otcextensions";
    tag = finalAttrs.version;
    hash = "sha256-dkAF0UXD0cpktSqDsYbpHO8IzKRdHx85MOp4aelbbgo=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    openstacksdk
    osc-lib
    oslo-config
    oslo-i18n
    python-novaclient
    python-openstackclient
  ];

  nativeCheckInputs = [
    mock
    oslotest
    prometheus-client
    requests-mock
    stestrCheckHook
  ];

  disabledTests = [
    # Requires networking
    "otcextensions.tests.unit.test_stats.TestNoStats.test_no_stats"
    "otcextensions.tests.unit.test_stats.TestStats.test_list_projects"
    "otcextensions.tests.unit.test_stats.TestStats.test_projects"
    "otcextensions.tests.unit.test_stats.TestStats.test_servers_error"
    "otcextensions.tests.unit.test_stats.TestStats.test_servers_no_detail"
    "otcextensions.tests.unit.test_stats.TestStats.test_sfsturbo_share"
    "otcextensions.tests.unit.test_stats.TestStats.test_timeout"
  ];

  pythonImportsCheck = [
    "otcextensions"
    "otcextensions.common"
    "otcextensions.osclient"
    "otcextensions.sdk"
  ];

  meta = {
    description = "OpenStack SDK and client extensions for Open Telekom Cloud services";
    homepage = "https://github.com/opentelekomcloud/python-otcextensions";
    changelog = "https://github.com/opentelekomcloud/python-otcextensions/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
