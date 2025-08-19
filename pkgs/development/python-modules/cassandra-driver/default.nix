{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  cython,
  eventlet,
  fetchFromGitHub,
  geomet,
  gevent,
  gremlinpython,
  iana-etc,
  libev,
  libredirect,
  pytestCheckHook,
  pytz,
  pyyaml,
  scales,
  six,
  sure,
  twisted,
  setuptools,
  distutils,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "cassandra-driver";
  version = "3.29.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datastax";
    repo = "python-driver";
    tag = version;
    hash = "sha256-RX9GLk2admzRasmP7LCwIfsJIt8TC/9rWhIcoTqS0qc=";
  };

  pythonRelaxDeps = [ "geomet" ];

  build-system = [
    distutils
    setuptools
    cython
  ];

  buildInputs = [ libev ];

  dependencies = [
    six
    geomet
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    pyyaml
    sure
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  # This is used to determine the version of cython that can be used
  CASS_DRIVER_ALLOWED_CYTHON_VERSION = cython.version;

  # Make /etc/protocols accessible to allow socket.getprotobyname('tcp') in sandbox,
  # also /etc/resolv.conf is referenced by some tests
  preCheck =
    (lib.optionalString stdenv.hostPlatform.isLinux ''
      echo "nameserver 127.0.0.1" > resolv.conf
      export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
      export LD_PRELOAD=${libredirect}/lib/libredirect.so
    '')
    + ''
      # increase tolerance for time-based test
      substituteInPlace tests/unit/io/utils.py --replace 'delta=.15' 'delta=.3'

      export HOME=$(mktemp -d)
      # cythonize this before we hide the source dir as it references
      # one of its files
      cythonize -i tests/unit/cython/types_testhelper.pyx

      mv cassandra .cassandra.hidden
    '';

  pythonImportsCheck = [ "cassandra" ];

  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  enabledTestPaths = [ "tests/unit" ];

  disabledTestPaths = [
    # requires puresasl
    "tests/unit/advanced/test_auth.py"
    # Uses asyncore, which is deprecated in python 3.12+
    "tests/unit/io/test_asyncorereactor.py"
  ];

  disabledTests = [
    # doesn't seem to be intended to be run directly
    "_PoolTests"
    # attempts to make connection to localhost
    "test_connection_initialization"
    # time-sensitive
    "test_nts_token_performance"
  ];

  optional-dependencies = {
    cle = [ cryptography ];
    eventlet = [ eventlet ];
    gevent = [ gevent ];
    graph = [ gremlinpython ];
    metrics = [ scales ];
    twisted = [ twisted ];
  };

  meta = {
    # cassandra/io/libevwrapper.c:668:10: error: implicit declaration of function ‘PyEval_ThreadsInitialized’ []
    broken = pythonAtLeast "3.13";
    description = "Python client driver for Apache Cassandra";
    homepage = "http://datastax.github.io/python-driver";
    changelog = "https://github.com/datastax/python-driver/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ris ];
  };
}
