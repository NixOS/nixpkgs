{
  lib,
  stdenv,
  buildPythonPackage,
  cheroot,
  fetchPypi,
  jaraco-collections,
  more-itertools,
  objgraph,
  path,
  portend,
  pyopenssl,
  pytest-forked,
  pytest-services,
  pytestCheckHook,
  python-memcached,
  pythonAtLeast,
  pythonOlder,
  requests-toolbelt,
  routes,
  setuptools-scm,
  simplejson,
  zc-lockfile,
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.10.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bHDnjuETAOiyHAdnxUKuaxAqScrFz9Tj4xPXu5B8WJE=";
  };

  postPatch = ''
    # Disable doctest plugin because times out
    substituteInPlace pytest.ini \
      --replace-fail "--doctest-modules" "-vvv" \
      --replace-fail "-p pytest_cov" "" \
      --replace-fail "--no-cov-on-fail" ""
    sed -i "/--cov/d" pytest.ini
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    cheroot
    jaraco-collections
    more-itertools
    portend
    zc-lockfile
  ];

  nativeCheckInputs = [
    objgraph
    path
    pytest-forked
    pytest-services
    pytestCheckHook
    requests-toolbelt
  ];

  preCheck = ''
    export CI=true
  '';

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTests =
    [
      # Keyboard interrupt ends test suite run
      "KeyboardInterrupt"
      # daemonize and autoreload tests have issue with sockets within sandbox
      "daemonize"
      "Autoreload"

      "test_antistampede"
      "test_file_stream"
      "test_basic_request"
      "test_3_Redirect"
      "test_4_File_deletion"
    ]
    ++ lib.optionals (pythonAtLeast "3.11") [
      "testErrorHandling"
      "testHookErrors"
      "test_HTTP10_KeepAlive"
      "test_No_Message_Body"
      "test_HTTP11_Timeout"
      "testGzip"
      "test_malformed_header"
      "test_no_content_length"
      "test_post_filename_with_special_characters"
      "test_post_multipart"
      "test_iterator"
      "test_1_Ram_Concurrency"
      "test_2_File_Concurrency"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_block" ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "cherrypy/test/test_config_server.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "cherrypy" ];

  optional-dependencies = {
    json = [ simplejson ];
    memcached_session = [ python-memcached ];
    routes_dispatcher = [ routes ];
    ssl = [ pyopenssl ];
    # not packaged yet
    xcgi = [
      # flup
    ];
  };

  meta = with lib; {
    description = "Object-oriented HTTP framework";
    mainProgram = "cherryd";
    homepage = "https://cherrypy.dev/";
    changelog = "https://github.com/cherrypy/cherrypy/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
