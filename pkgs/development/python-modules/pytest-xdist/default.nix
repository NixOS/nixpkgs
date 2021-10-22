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
  version = "2.4.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89b330316f7fc475f999c81b577c2b926c9569f3d397ae432c0c2e2496d61ff9";
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
