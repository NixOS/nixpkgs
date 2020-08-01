{ stdenv, lib, buildPythonPackage, fetchPypi, python, pythonOlder
, cython
, eventlet
, futures
, iana-etc
, geomet
, libev
, mock
, nose
, pytest
, pytz
, pyyaml
, scales
, six
, sure
, gremlinpython
, gevent
, twisted
}:

buildPythonPackage rec {
  pname = "cassandra-driver";
  version = "3.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83ec8d9a5827ee44bb1c0601a63696a8a9086beaf0151c8255556299246081bd";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ libev ];
  propagatedBuildInputs = [ six geomet ]
    ++ lib.optionals (pythonOlder "3.4") [ futures ];

  # Make /etc/protocols accessible to fix socket.getprotobyname('tcp') in sandbox.
  # Prevents `error: protocol not found`.
  # See https://github.com/NixOS/nixpkgs/pull/91662#issuecomment-666727467.
  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols
  '';
  postCheck = "unset NIX_REDIRECTS";

  checkInputs = [ eventlet mock nose pytest pytz pyyaml sure scales gremlinpython gevent twisted ];

  # ignore test files which try to do socket.getprotocolname('tcp')
  # as it fails in sandbox mode due to lack of a /etc/protocols file
  # checkPhase = ''
  #   pytest tests/unit \
  #     --ignore=tests/unit/io/test_libevreactor.py \
      # --ignore=tests/unit/io/test_eventletreactor.py \
  #     --ignore=tests/unit/io/test_asyncorereactor.py
  # '';
  # disabledTests = [
  #   "test_libevreactor"
  #   "test_eventletreactor"
  #   "test_asyncorereactor"
  #   "test_asyncioreactor"
  #   "test_twistedreactor"
  # ];
  # Disabling them via disabledTests won't work because already building them seems to fail?
  pytestFlagsArray = [
    "--ignore=tests/unit/io/test_libevreactor.py"
    "--ignore=tests/unit/io/test_eventletreactor.py"
    "--ignore=tests/unit/io/test_asyncorereactor.py"
    "--ignore=tests/unit/io/test_asyncioreactor.py"
    "--ignore=tests/unit/io/test_twistedreactor.py"
  ];
  # TODO Maybe the flags were added much earlier back when there were only three tests in io
  # doCheck = false;

  meta = with lib; {
    description = "A Python client driver for Apache Cassandra";
    homepage = "http://datastax.github.io/python-driver";
    license = licenses.asl20;
    maintainers = with maintainers; [ turion ];
  };
}
