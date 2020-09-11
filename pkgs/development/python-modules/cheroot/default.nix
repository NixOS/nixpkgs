{ lib, stdenv, fetchPypi, buildPythonPackage, isPy3k
, jaraco_text
, more-itertools
, portend
, pyopenssl
, pytestCheckHook
, pytestcov
, pytest-mock
, pytest-testmon
, requests
, requests-toolbelt
, requests-unixsocket
, setuptools_scm
, setuptools-scm-git-archive
, six
, trustme
}:

buildPythonPackage rec {
  pname = "cheroot";
  version = "8.4.5";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6c18caf5f79cdae668c35fc8309fc88ea4a964cce9e2ca8504fab13bcf57301";
  };

  nativeBuildInputs = [ setuptools_scm setuptools-scm-git-archive ];

  propagatedBuildInputs = [ more-itertools six ];

  checkInputs = [
    jaraco_text
    portend
    pyopenssl
    pytestCheckHook
    pytestcov
    pytest-mock
    pytest-testmon
    requests
    requests-toolbelt
    requests-unixsocket
    trustme
  ];

  # avoid attempting to use 3 packages not available on nixpkgs
  # (jaraco.apt, jaraco.context, yg.lockfile)
  pytestFlagsArray = [ "--ignore=cheroot/test/test_wsgi.py" ];

  # Disable doctest plugin because times out
  # Disable xdist (-n arg) because it's incompatible with testmon
  # Deselect test_bind_addr_unix on darwin because times out
  # Deselect test_http_over_https_error on darwin because builtin cert fails
  # Disable warnings-as-errors because of deprecation warnings from socks on python 3.7
  # adds many other pytest utilities which aren't necessary like linting
  preCheck = ''
    rm pytest.ini
  '';

  disabledTests= [
    "tls" # touches network
    "peercreds_unix_sock" # test urls no longer allowed
  ] ++ lib.optionals stdenv.isDarwin [
    "http_over_https_error"
    "bind_addr_unix"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "High-performance, pure-Python HTTP";
    homepage = "https://github.com/cherrypy/cheroot";
    license = licenses.mit;
  };
}
