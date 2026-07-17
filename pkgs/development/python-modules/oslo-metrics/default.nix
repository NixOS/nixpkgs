{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pbr,

  # dependencies
  oslo-config,
  oslo-log,
  oslo-utils,
  prometheus-client,

  # tests
  oslotest,
  stestr,
}:

buildPythonPackage rec {
  pname = "oslo-metrics";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.metrics";
    tag = version;
    hash = "sha256-LV4NGHs0lBtktjzboOsPOnA56QqjnaKwtGGdy5WlW6Q=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
  ];

  dependencies = [
    oslo-config
    oslo-log
    oslo-utils
    prometheus-client
  ];

  nativeCheckInputs = [
    oslotest
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "oslo_metrics" ];

  meta = {
    description = "OpenStack library for collecting metrics from Oslo libraries";
    homepage = "https://github.com/openstack/oslo.metrics";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
