{ lib
, stdenv
, buildPythonPackage
, cryptography
, cython
, eventlet
, fetchFromGitHub
, geomet
, gevent
, gremlinpython
, iana-etc
, libev
, libredirect
, mock
, nose
, pytestCheckHook
, pythonOlder
, pytz
, pyyaml
, scales
, six
, sure
, twisted
}:

buildPythonPackage rec {
  pname = "cassandra-driver";
  version = "3.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "datastax";
    repo = "python-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-5JRbzYl7ftgK6GuvXWdvo52ZlS1th9JyLAYu/UCcPVc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'geomet>=0.1,<0.3' 'geomet'
  '';

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    libev
  ];

  propagatedBuildInputs = [
    six
    geomet
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    nose
    pytz
    pyyaml
    sure
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  # Make /etc/protocols accessible to allow socket.getprotobyname('tcp') in sandbox,
  # also /etc/resolv.conf is referenced by some tests
  preCheck = (lib.optionalString stdenv.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
  '') + ''
    # increase tolerance for time-based test
    substituteInPlace tests/unit/io/utils.py --replace 'delta=.15' 'delta=.3'

    export HOME=$(mktemp -d)
    # cythonize this before we hide the source dir as it references
    # one of its files
    cythonize -i tests/unit/cython/types_testhelper.pyx

    mv cassandra .cassandra.hidden
  '';

  pythonImportsCheck = [
    "cassandra"
  ];

  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  pytestFlagsArray = [
    "tests/unit"
  ];

  disabledTestPaths = [
    # requires puresasl
    "tests/unit/advanced/test_auth.py"
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

  meta = with lib; {
    description = "A Python client driver for Apache Cassandra";
    homepage = "http://datastax.github.io/python-driver";
    changelog = "https://github.com/datastax/python-driver/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
