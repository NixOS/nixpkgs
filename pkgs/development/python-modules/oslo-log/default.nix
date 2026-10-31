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

buildPythonPackage (finalAttrs: {
  pname = "oslo-log";
  version = "8.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.log";
    tag = finalAttrs.version;
    hash = "sha256-b57pX/+wFZV0vtMKqIUtVZBmlhTd5rZaqV8NSv9vfaQ=";
  };

  # Manually set version because prb wants to get it from the git upstream repository (and we are
  # installing from tarball instead)
  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include oslo_log *" > MANIFEST.in
  '';

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

  pythonImportsCheck = [
    "oslo_log"
    "oslo_log.cmds"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "oslo.log library";
    mainProgram = "convert-json";
    homepage = "https://github.com/openstack/oslo.log";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
