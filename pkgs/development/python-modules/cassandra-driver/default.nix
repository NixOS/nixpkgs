{ stdenv, lib, buildPythonPackage, fetchPypi, python, pythonOlder
, cython
, eventlet
, futures
, libev
, mock
, nose
, pytest
, pytz
, pyyaml
, scales
, six
, sure
}:

buildPythonPackage rec {
  pname = "cassandra-driver";
  version = "3.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vy9yzsd9c29irq99m8lpkgnc634waai2phvr6b89pmmdirp2wm9";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ libev ];
  propagatedBuildInputs = [ six ]
    ++ lib.optionals (pythonOlder "3.4") [ futures ];

  checkInputs = [ eventlet mock nose pytest pytz pyyaml sure ];

  # ignore test files which try to do socket.getprotocolname('tcp')
  # as it fails in sandbox mode due to lack of a /etc/protocols file
  checkPhase = ''
    pytest tests/unit \
      --ignore=tests/unit/io/test_libevreactor.py \
      --ignore=tests/unit/io/test_eventletreactor.py \
      --ignore=tests/unit/io/test_asyncorereactor.py
  '';

  meta = with lib; {
    description = "A Python client driver for Apache Cassandra";
    homepage = "http://datastax.github.io/python-driver";
    license = licenses.asl20;
  };
}
