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
}:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "2.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8ecde2f85d88fbcadb7d28cb33da0fa29bca5cf7d5967fa89fc0e97e5299ea5";
  };

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [
    pytest
  ];
  checkInputs = [ pytestCheckHook filelock ];
  propagatedBuildInputs = [ execnet pytest-forked psutil ];

  # access file system
  disabledTests = [
    "test_distribution_rsyncdirs_example"
    "test_rsync_popen_with_path"
    "test_popen_rsync_subdir"
    "test_rsync_report"
    "test_init_rsync_roots"
    "test_rsyncignore"
  ];

  meta = with lib; {
    description = "Pytest xdist plugin for distributed testing and loop-on-failing modes";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
