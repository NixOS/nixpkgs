{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  keystoneauth1,
  mock,
  openstacksdk,
  osc-lib,
  oslo-i18n,
  oslotest,
  pbr,
  prometheus-client,
  python-novaclient,
  python-openstackclient,
  requests-mock,
  requests,
  setuptools,
  stestr,
  writeText,
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
    cryptography
    keystoneauth1
    openstacksdk
    osc-lib
    oslo-i18n
    pbr
    python-novaclient
    python-openstackclient
    requests
  ];

  nativeCheckInputs = [
    mock
    oslotest
    prometheus-client
    requests-mock
    stestr
  ];

  checkPhase =
    let
      disabledTests = [
        # Requires networking
        "otcextensions.tests.unit.test_stats"
      ];
    in
    ''
      runHook preCheck
      stestr run -e ${writeText "disabled-tests" (lib.concatStringsSep "\n" disabledTests)}
      runHook postCheck
    '';

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
