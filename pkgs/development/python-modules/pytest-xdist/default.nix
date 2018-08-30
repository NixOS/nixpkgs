{ stdenv, fetchPypi, buildPythonPackage, execnet, pytest, setuptools_scm, pytest-forked }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "1.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28e25e79698b2662b648319d3971c0f9ae0e6500f88258ccb9b153c31110ba9b";
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
