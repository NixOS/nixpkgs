{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  debtcollector,
  oslo-config,
  oslo-context,
  oslo-serialization,
  oslo-utils,
  pbr,
  python-dateutil,
  pyinotify,

  # tests
  eventlet,
  oslotest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oslo-log";
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.log";
    tag = version;
    hash = "sha256-XCQc0ByjnXU4/ArgJ6sGgm/EO2DevDdBgma85pjhdSc=";
  };

  # Manually set version because prb wants to get it from the git upstream repository (and we are
  # installing from tarball instead)
  PBR_VERSION = version;

  build-system = [ setuptools ];

  dependencies = [
    debtcollector
    oslo-config
    oslo-context
    oslo-serialization
    oslo-utils
    pbr
    python-dateutil
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pyinotify ];

  nativeCheckInputs = [
    eventlet
    oslotest
    pytestCheckHook
  ];

  disabledTests = [
    # not compatible with sandbox
    "test_logging_handle_error"
    # Incompatible Exception Representation, displaying natively
    "test_rate_limit"
    "test_rate_limit_except_level"
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
