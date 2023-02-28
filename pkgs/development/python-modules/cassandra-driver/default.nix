{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cython
, eventlet
, futures ? null
, iana-etc
, geomet
, libev
, mock
, nose
, pytestCheckHook
, pytz
, pyyaml
, scales
, six
, sure
, gremlinpython
, gevent
, twisted
, libredirect
}:

buildPythonPackage rec {
  pname = "cassandra-driver";
  version = "3.25.0";

  # pypi tarball doesn't include tests
  src = fetchFromGitHub {
    owner = "datastax";
    repo = "python-driver";
    rev = version;
    sha256 = "1dn7iiavsrhh6i9hcyw0mk8j95r5ym0gbrvdca998hx2rnz5ark6";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'geomet>=0.1,<0.3' 'geomet'
  '';

  nativeBuildInputs = [ cython ];
  buildInputs = [ libev ];
  propagatedBuildInputs = [ six geomet ]
    ++ lib.optionals (pythonOlder "3.4") [ futures ];

  # Make /etc/protocols accessible to allow socket.getprotobyname('tcp') in sandbox,
  # also /etc/resolv.conf is referenced by some tests
  preCheck = (lib.optionalString stdenv.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
  '') + ''
    # increase tolerance for time-based test
    substituteInPlace tests/unit/io/utils.py --replace 'delta=.15' 'delta=.3'
  '';
  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  nativeCheckInputs = [
    pytestCheckHook
    eventlet
    mock
    nose
    pytz
    pyyaml
    sure
    scales
    gremlinpython
    gevent
    twisted
  ];

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

  meta = with lib; {
    description = "A Python client driver for Apache Cassandra";
    homepage = "http://datastax.github.io/python-driver";
    license = licenses.asl20;
    maintainers = with maintainers; [ turion ris ];
  };
}
