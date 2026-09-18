{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  debtcollector,
  oslo-config,
  oslo-context,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  python-dateutil,

  # tests
  eventlet,
  oslotest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oslo-log";
  version = "8.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.log";
    tag = version;
    hash = "sha256-teESuCQg8fxCWPMUWTTYyBIGSn9m916Uoy3UkWArVVs=";
  };

  # Manually set version because prb wants to get it from the git upstream repository (and we are
  # installing from tarball instead)
  env.PBR_VERSION = version;

  build-system = [ setuptools ];

  dependencies = [
    debtcollector
    oslo-config
    oslo-context
    oslo-i18n
    oslo-serialization
    oslo-utils
    pbr
    python-dateutil
  ];

  nativeCheckInputs = [
    eventlet
    oslotest
    pytestCheckHook
  ];

  disabledTests = [
    # Incompatible Exception Representation, displaying natively
    "test_logging_handle_error"
    "test_rotate_log"
    "test_timed_rotate_log"
  ];

  pythonImportsCheck = [ "oslo_log" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "oslo.log library";
    mainProgram = "convert-json";
    homepage = "https://github.com/openstack/oslo.log";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
