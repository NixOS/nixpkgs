{ stdenv, fetchPypi, buildPythonPackage, execnet, pytest
, setuptools_scm, pytest-forked, filelock, six, isPy3k }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "1.32.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d4166dcac69adb38eeaedb88c8fada8588348258a3492ab49ba9161f2971129";
  };

  nativeBuildInputs = [ setuptools_scm pytest ];
  checkInputs = [ pytest filelock ];
  propagatedBuildInputs = [ execnet pytest-forked six ];

  # Encountered a memory leak
  # https://github.com/pytest-dev/pytest-xdist/issues/462
  doCheck = !isPy3k;

  checkPhase = ''
    # Excluded tests access file system
    py.test testing -k "not test_distribution_rsyncdirs_example \
                    and not test_rsync_popen_with_path \
                    and not test_popen_rsync_subdir \
                    and not test_init_rsync_roots \
                    and not test_rsyncignore"
  '';

  meta = with stdenv.lib; {
    description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
