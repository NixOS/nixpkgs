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

buildPythonPackage rec {
  pname = "python-otcextensions";
  version = "0.32.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opentelekomcloud";
    repo = "python-otcextensions";
    tag = version;
    hash = "sha256-hqxCnIfVJPnlwree0+kY9iXXjPMoGd06tVT+yT6rex8=";
  };

  env.PBR_VERSION = version;

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
    changelog = "https://github.com/opentelekomcloud/python-otcextensions/releases/tag/${version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
