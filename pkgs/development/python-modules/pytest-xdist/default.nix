{ stdenv, fetchPypi, buildPythonPackage, execnet, pytest, setuptools_scm, pytest-forked, filelock, six }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "1.24.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "909bb938bdb21e68a28a8d58c16a112b30da088407b678633efb01067e3923de";
  };

  nativeBuildInputs = [ setuptools_scm pytest ];
  checkInputs = [ pytest filelock ];
  propagatedBuildInputs = [ execnet pytest-forked six ];

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
    homepage = https://github.com/pytest-dev/pytest-xdist;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
