{ stdenv, fetchPypi, buildPythonPackage, execnet, pytest, setuptools_scm, pytest-forked }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "1.23.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ef0d05c905cfa0c5442c90e9e350e65c6ada120e33a00a066ca51c89f5f869a";
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
