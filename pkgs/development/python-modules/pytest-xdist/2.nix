{ stdenv, fetchPypi, buildPythonPackage, execnet, pytest_6
, setuptools_scm, pytest-forked, filelock, psutil, six, isPy3k }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "2.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "82d938f1a24186520e2d9d3a64ef7d9ac7ecdf1a0659e095d18e596b8cbd0672";
  };

  nativeBuildInputs = [ setuptools_scm pytest_6 ];
  checkInputs = [ pytest_6 filelock ];
  propagatedBuildInputs = [ execnet pytest-forked psutil six ];

  # pytest6 doesn't allow for new lines
  checkPhase = ''
    # Excluded tests access file system
    export HOME=$TMPDIR
    pytest -n $NIX_BUILD_CORES -k "not (distribution_rsyncdirs_example or rsync)"
  '';

  meta = with stdenv.lib; {
    description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
