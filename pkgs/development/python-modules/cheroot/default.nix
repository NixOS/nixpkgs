{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, jaraco_functools
, jaraco_text
, more-itertools
, portend
, pypytools
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests-toolbelt
, requests-unixsocket
, setuptools-scm
, setuptools-scm-git-archive
, six
}:

buildPythonPackage rec {
  pname = "cheroot";
  version = "9.0.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PUetnuGey+wUS0dYOZA2aS/b9npAuW7vH7FFQ2ez0zg=";
  };

  nativeBuildInputs = [
    setuptools-scm
    setuptools-scm-git-archive
  ];

  propagatedBuildInputs = [
    jaraco_functools
    more-itertools
    six
  ];

  checkInputs = [
    jaraco_text
    portend
    pypytools
    pytest-mock
    pytestCheckHook
    requests
    requests-toolbelt
    requests-unixsocket
  ];

  # Disable doctest plugin because times out
  # Disable xdist (-n arg) because it's incompatible with testmon
  # Deselect test_bind_addr_unix on darwin because times out
  # Deselect test_http_over_https_error on darwin because builtin cert fails
  # Disable warnings-as-errors because of deprecation warnings from socks on python 3.7
  # Disable pytest-testmon because it doesn't work
  # adds many other pytest utilities which aren't necessary like linting
  preCheck = ''
    rm pytest.ini
  '';

  disabledTests = [
    "tls" # touches network
    "peercreds_unix_sock" # test urls no longer allowed
  ] ++ lib.optionals stdenv.isDarwin [
    "http_over_https_error"
    "bind_addr_unix"
    "test_ssl_env"
  ];

  disabledTestPaths = [
    # avoid attempting to use 3 packages not available on nixpkgs
    # (jaraco.apt, jaraco.context, yg.lockfile)
    "cheroot/test/test_wsgi.py"
    # requires pyopenssl
    "cheroot/test/test_ssl.py"
  ];

  pythonImportsCheck = [
    "cheroot"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "High-performance, pure-Python HTTP";
    homepage = "https://github.com/cherrypy/cheroot";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
