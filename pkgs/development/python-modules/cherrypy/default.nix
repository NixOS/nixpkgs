{
  lib,
  stdenv,
  buildPythonPackage,
  cheroot,
  fetchpatch,
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
  version = "18.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    hash = "sha256-awbBkc5xqGRh8wVyoatX/8CfQxQ7qOQsEDx7M0ciDrE=";
  };

  patches = [
    # Replace distutils.spawn.find_executable with shutil.which, https://github.com/cherrypy/cherrypy/pull/2023
    (fetchpatch {
      name = "remove-distutils.patch";
      url = "https://github.com/cherrypy/cherrypy/commit/8a19dd5f1e712a326a3613b17e6fc900012ed09a.patch";
      hash = "sha256-fXECX0CdU74usiq9GEkIG9CF+dueszblT4qOeF6B700=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_scm_git_archive >= 1.1",' ""
    # Disable doctest plugin because times out
    substituteInPlace pytest.ini \
      --replace-fail "--doctest-modules" "-vvv" \
      --replace-fail "-p pytest_cov" "" \
      --replace-fail "--no-cov-on-fail" ""
    sed -i "/--cov/d" pytest.ini
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
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
    ++ lib.optionals stdenv.isDarwin [ "test_block" ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [ "cherrypy/test/test_config_server.py" ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "cherrypy" ];

  passthru.optional-dependencies = {
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
    maintainers = with maintainers; [ ];
  };
}
