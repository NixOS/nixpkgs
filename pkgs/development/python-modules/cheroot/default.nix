{ stdenv, fetchPypi, buildPythonPackage, fetchpatch
, more-itertools, six
, pytest, pytestcov, portend
, backports_unittest-mock
, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "cheroot";
  version = "6.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e3ac15e1efffc81425a693e99b3c09d7ea4bf947255d8d4c38e2cf76f3a4d25";
  };

  patches = fetchpatch {
    name = "cheroot-fix-setup-python3.patch";
    url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/cheroot-fix-setup-python3.patch?h=packages/python-cheroot";
    sha256 = "1rlgz0qln536y00mfqlf0i9hz3f53id73wh47cg5q2vcsw1w2bpc";
  };

  propagatedBuildInputs = [ more-itertools six backports_functools_lru_cache ];

  checkInputs = [ pytest pytestcov portend backports_unittest-mock ];

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
