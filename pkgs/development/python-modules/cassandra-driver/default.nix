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
  version = "3.20.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03nycyn5nd1pnrg6fffq3wcjqnw13lgja137zq5zszx68mc15wnl";
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
