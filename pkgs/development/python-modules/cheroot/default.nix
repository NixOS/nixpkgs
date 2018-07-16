{ stdenv, fetchPypi, buildPythonPackage
, more-itertools, six
, pytest, pytestcov, portend
, backports_unittest-mock
, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "cheroot";
  version = "6.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52f915d077ce6201e59c95c4a2ef89617d9b90e6185defb40c03ff3515d2066f";
  };

  propagatedBuildInputs = [ more-itertools six ];

  checkInputs = [ pytest pytestcov portend backports_unittest-mock backports_functools_lru_cache ];

# Disable testmon, it needs pytest-testmon, which we do not currently have in nikpkgs,
# and is only used to skip some tests that are already known to work.
  postPatch = ''
    substituteInPlace "./pytest.ini" --replace "--testmon" ""
    substituteInPlace setup.py --replace "use_scm_version=True" "version=\"${version}\"" \
  --replace "'setuptools_scm>=1.15.0'," "" \
  --replace "'setuptools_scm_git_archive>=1.0'," "" \
  '';

  checkPhase = ''
    py.test cheroot
  '';

  meta = with stdenv.lib; {
    description = "High-performance, pure-Python HTTP";
    homepage = https://github.com/cherrypy/cheroot;
    license = licenses.mit;
  };
}
