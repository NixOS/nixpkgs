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
  stestrCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "oslo-metrics";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.metrics";
    tag = finalAttrs.version;
    hash = "sha256-LV4NGHs0lBtktjzboOsPOnA56QqjnaKwtGGdy5WlW6Q=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include oslo_metrics *" > MANIFEST.in
  '';

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
    stestrCheckHook
  ];

  pythonImportsCheck = [
    "oslo_metrics"
    "oslo_metrics.metrics"
  ];

  meta = {
    description = "OpenStack library for collecting metrics from Oslo libraries";
    homepage = "https://github.com/openstack/oslo.metrics";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
