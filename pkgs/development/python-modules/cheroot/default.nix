{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  jaraco-functools,
  jaraco-text,
  more-itertools,
  portend,
  pypytools,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-toolbelt,
  requests-unixsocket,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "cheroot";
  version = "10.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4LgveXZY0muGE+yOtWPDsI5r1qeSHp1Qib0Rda0bF0A=";
  };

  # remove setuptools-scm-git-archive dependency
  # https://github.com/cherrypy/cheroot/commit/f0c51af263e20f332c6f675aa90ec6705ae4f5d1
  # there is a difference between the github source and the pypi tarball source,
  # and it is not easy to apply patches.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"setuptools_scm_git_archive>=1.1",' ""
    substituteInPlace setup.cfg \
      --replace "setuptools_scm_git_archive>=1.0" ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    jaraco-functools
    more-itertools
    six
  ];

  nativeCheckInputs = [
    jaraco-text
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

  disabledTests =
    [
      "tls" # touches network
      "peercreds_unix_sock" # test urls no longer allowed
    ]
    ++ lib.optionals stdenv.isDarwin [
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

  pythonImportsCheck = [ "cheroot" ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "High-performance, pure-Python HTTP";
    mainProgram = "cheroot";
    homepage = "https://github.com/cherrypy/cheroot";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
