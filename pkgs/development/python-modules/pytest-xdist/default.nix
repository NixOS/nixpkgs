{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, pytestCheckHook
, filelock
, execnet
, pytest
, pytest-forked
, psutil
, pexpect
}:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "2.5.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RYDeyj/wTdsqxT66Oddstd1e3qwFDLb7x2iw3XErTt8=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [
    pytest
  ];
  checkInputs = [ pytestCheckHook filelock pexpect ];
  propagatedBuildInputs = [ execnet pytest-forked psutil ];

  pytestFlagsArray = [
    # pytest can already use xdist at this point
    "--numprocesses=$NIX_BUILD_CORES"
    "--forked"
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
    description = "Pytest xdist plugin for distributed testing and loop-on-failing modes";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
