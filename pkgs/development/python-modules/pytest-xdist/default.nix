{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools_scm
, pytestCheckHook
, filelock
, execnet
, pytest
, pytest-forked
, psutil
}:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "2.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "718887296892f92683f6a51f25a3ae584993b06f7076ce1e1fd482e59a8220a2";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytestCheckHook filelock ];
  propagatedBuildInputs = [ execnet pytest pytest-forked psutil ];

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
    description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
