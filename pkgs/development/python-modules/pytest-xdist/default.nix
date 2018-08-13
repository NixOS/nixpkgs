{ stdenv, fetchPypi, buildPythonPackage, execnet, pytest, setuptools_scm, pytest-forked }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "1.22.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3308c4f6221670432d01e0b393b333d77c1fd805532e1d64450e8140855eb51b";
  };

  nativeBuildInputs = [ setuptools_scm ];
  buildInputs = [ pytest pytest-forked ];
  propagatedBuildInputs = [ execnet ];

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
  };
}
