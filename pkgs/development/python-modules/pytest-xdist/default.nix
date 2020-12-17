{ stdenv, fetchPypi, buildPythonPackage, execnet, pytest_6
, setuptools_scm, pytest-forked, filelock, psutil, six, isPy3k }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "2.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wh6pn66nncfs6ay0n863bgyriwsgppn8flx5l7551j1lbqkinc2";
  };

  nativeBuildInputs = [ setuptools_scm pytest_6 ];
  checkInputs = [ pytest_6 filelock ];
  propagatedBuildInputs = [ execnet pytest-forked psutil six ];

  # pytest6 doesn't allow for new lines
  # capture_deprecated not compatible with latest pytest6
  checkPhase = ''
    # Excluded tests access file system
    export HOME=$TMPDIR
    pytest -n $NIX_BUILD_CORES \
      -k "not (distribution_rsyncdirs_example or rsync or warning_captured_deprecated_in_pytest_6)"
  '';

  meta = with stdenv.lib; {
    description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
