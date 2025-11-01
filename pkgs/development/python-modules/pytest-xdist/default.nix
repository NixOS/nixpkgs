{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  filelock,
  execnet,
  pytest,
  psutil,
  setproctitle,
}:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-xdist";
    tag = "v${version}";
    hash = "sha256-2x3znm92wo8DCshf5sYK0stnESg0oVXbxsWRAaTj6oQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [ execnet ];

  nativeCheckInputs = [
    filelock
    pytestCheckHook
  ];

  optional-dependencies = {
    psutil = [ psutil ];
    setproctitle = [ setproctitle ];
  };

  # pytest can already use xdist at this point
  preCheck = ''
    appendToVar pytestFlags "--numprocesses=$NIX_BUILD_CORES"
  '';

  # access file system
  disabledTests = [
    "test_distribution_rsyncdirs_example"
    "test_rsync_popen_with_path"
    "test_popen_rsync_subdir"
    "test_rsync_report"
    "test_init_rsync_roots"
    "test_rsyncignore"
    # flakey
    "test_internal_errors_propagate_to_controller"
    # https://github.com/pytest-dev/pytest-xdist/issues/985
    "test_workqueue_ordered_by_size"
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    changelog = "https://github.com/pytest-dev/pytest-xdist/blob/${src.tag}/CHANGELOG.rst";
    description = "Pytest plugin for distributed testing";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
