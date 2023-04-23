{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, pytestCheckHook
, filelock
, execnet
, pytest
, psutil
, setproctitle
}:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "3.2.1";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GEm9mNiyQrlI5HLbdHjgkL8zYZEqj+2HmS7ZQIX1Ryc=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    execnet
  ];

  nativeCheckInputs = [
    filelock
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    psutil = [ psutil ];
    setproctitle = [ setproctitle ];
  };

  pytestFlagsArray = [
    # pytest can already use xdist at this point
    "--numprocesses=$NIX_BUILD_CORES"
  ];

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
  ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    changelog = "https://github.com/pytest-dev/pytest-xdist/blob/v${version}/CHANGELOG.rst";
    description = "Pytest xdist plugin for distributed testing and loop-on-failing modes";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
