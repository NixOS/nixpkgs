{
  lib,
  buildPythonPackage,
  fetchFromGitea,

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
  version = "0.11.0";
  format = "setuptools";

  src = fetchFromGitea {
    domain = "opendev.org";
    owner = "openstack";
    repo = "oslo.metrics";
    tag = version;
    hash = "sha256-PiMrfVWRV3GQPJ7PnXzhAdTncXcFDPZFd+sMHVr65UU=";
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

  meta = with lib; {
    description = "OpenStack library for collecting metrics from Oslo libraries";
    homepage = "https://opendev.org/openstack/oslo.metrics";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
