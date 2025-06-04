{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.log";
    tag = version;
    hash = "sha256-ybWrNwP9L7iOzft10TgRFxA4mCRDVozVC2ZAopgITqo=";
  };

  patches = [
    # remove removed alias from tests
    (fetchpatch {
      url = "https://github.com/openstack/oslo.log/commit/69a285a8c830712b4b8aafc8ecd4e2d7654e1ffe.patch";
      hash = "sha256-e0kRSHJPHITP/XgPHhY5kGzCupE00oBnCJYiUCs3Yks=";
    })
  ];

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
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ pyinotify ];

  nativeCheckInputs = [
    eventlet
    oslotest
    pytestCheckHook
  ];

  disabledTests = [
    # not compatible with sandbox
    "test_logging_handle_error"
    # File which is used doesn't seem not to be present
    "test_log_config_append_invalid"
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
