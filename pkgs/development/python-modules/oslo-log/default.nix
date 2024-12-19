{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
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
  version = "6.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.log";
    rev = "refs/tags/${version}";
    hash = "sha256-IEhIhGE95zZiWp602rFc+NLco/Oyx9XEL5e2RExNBMs=";
  };

  # Manually set version because prb wants to get it from the git upstream repository (and we are
  # installing from tarball instead)
  PBR_VERSION = version;

  build-system = [ setuptools ];

  dependencies = [
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
    maintainers = lib.teams.openstack.members;
  };
}
