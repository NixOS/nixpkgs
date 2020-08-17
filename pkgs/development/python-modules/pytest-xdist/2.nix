{ stdenv, fetchPypi, buildPythonPackage, execnet, pytest_6
, setuptools_scm, pytest-forked, filelock, psutil, six, isPy3k }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "2.0.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3217b1f40290570bf27b1f82714fc4ed44c3260ba9b2f6cde0372378fc707ad3";
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
