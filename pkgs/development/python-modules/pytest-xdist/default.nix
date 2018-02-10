{ stdenv, fetchPypi, buildPythonPackage, isPy3k, execnet, pytest, setuptools_scm, pytest-forked }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "1.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65228a859191f2c74ee68c127317eefe35eedd3d43fc1431f19240663b0cafcd";
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
