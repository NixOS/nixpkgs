{ stdenv, fetchPypi, buildPythonPackage
, more-itertools, six, setuptools_scm, setuptools-scm-git-archive
, pytest, pytestcov, portend, pytest-testmon, pytest-mock
, backports_unittest-mock, pyopenssl, requests, trustme, requests-unixsocket
, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "cheroot";
  version = "6.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6a85e005adb5bc5f3a92b998ff0e48795d4d98a0fbb7edde47a7513d4100601";
  };

  nativeBuildInputs = [ setuptools_scm setuptools-scm-git-archive ];

  propagatedBuildInputs = [ more-itertools six backports_functools_lru_cache ];

  checkInputs = [ pytest pytestcov portend backports_unittest-mock pytest-mock pytest-testmon pyopenssl requests trustme requests-unixsocket ];

  # Disable doctest plugin because times out
  # Deselect test_bind_addr_unix on darwin because times out
  # Deselect test_http_over_https_error on darwin because builtin cert fails
  checkPhase = ''
    substituteInPlace pytest.ini --replace "--doctest-modules" ""
    pytest ${stdenv.lib.optionalString stdenv.isDarwin "--deselect=cheroot/test/test_ssl.py::test_http_over_https_error --deselect=cheroot/test/test_server.py::test_bind_addr_unix"}
  '';

  meta = with stdenv.lib; {
    description = "High-performance, pure-Python HTTP";
    homepage = https://github.com/cherrypy/cheroot;
    license = licenses.mit;
  };
}
