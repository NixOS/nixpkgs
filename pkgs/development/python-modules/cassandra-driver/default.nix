{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  cython,
  eventlet,
  fetchFromGitHub,
  fetchpatch2,
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
}:

buildPythonPackage rec {
  pname = "cassandra-driver";
  version = "3.29.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datastax";
    repo = "python-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-pnNm5Pd5k4bt+s3GrUUDWRpSdqNSM89GiX8DZKYzW1E=";
  };

  patches = [
    # https://github.com/datastax/python-driver/pull/1201
    # Also needed for below patch to apply
    (fetchpatch2 {
      name = "remove-mock-dependency.patch";
      url = "https://github.com/datastax/python-driver/commit/9aca00be33d96559f0eabc1c8a26bb439dcebbd7.patch";
      hash = "sha256-ZN95V8ebbjahzqBat2oKBJLfu0fqbWMvAu0DzfVGw8I=";
    })
    # https://github.com/datastax/python-driver/pull/1215
    (fetchpatch2 {
      name = "convert-to-pytest.patch";
      url = "https://github.com/datastax/python-driver/commit/9952e2ab22c7e034b96cc89330791d73c221546b.patch";
      hash = "sha256-xa2aV6drBcgkQT05kt44vwupg3oMHLbcbZSQ7EHKnko=";
    })
    # https://github.com/datastax/python-driver/pull/1195
    (fetchpatch2 {
      name = "remove-assertRaisesRegexp.patch";
      url = "https://github.com/datastax/python-driver/commit/622523b83971e8a181eb4853b7d877420c0351ef.patch";
      hash = "sha256-Q8pRhHBLKyenMfrITf8kDv3BbsSCDAmVisTr4jSAIvA=";
    })
  ];

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
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

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

  pytestFlagsArray = [ "tests/unit" ];

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

  passthru.optional-dependencies = {
    cle = [ cryptography ];
    eventlet = [ eventlet ];
    gevent = [ gevent ];
    graph = [ gremlinpython ];
    metrics = [ scales ];
    twisted = [ twisted ];
  };

  meta = {
    description = "Python client driver for Apache Cassandra";
    homepage = "http://datastax.github.io/python-driver";
    changelog = "https://github.com/datastax/python-driver/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ris ];
  };
}
