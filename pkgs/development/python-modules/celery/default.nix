{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, iana-etc, libredirect,
  pytest, case, kombu, billiard, pytz, anyjson, amqp, eventlet
}:

let

  # Needed for celery
  pytest_32 = pytest.overridePythonAttrs( oldAttrs: rec {
    version = "3.2.5";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "6d5bd4f7113b444c55a3bbb5c738a3dd80d43563d063fc42dcb0aaefbdd78b81";
    };
  });

in buildPythonPackage rec {
  pname = "celery";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff727c115533edbc7b81b2b4ba1ec88d1c2fc4836e1e2f4c3c33a76ff53e5d7f";
  };

  # Skip test_RedisBackend.test_timeouts_in_url_coerced
  # See https://github.com/celery/celery/pull/4847
  patches = fetchpatch {
    url = https://github.com/celery/celery/commit/b2668607c909c61becd151905b4525190c19ff4a.patch;
    sha256 = "11w0z2ycyh8kccj4y69zb7bxppiipcwwigg6jn1q9yrcsvz170jq";
  };

  # make /etc/protocols accessible to fix socket.getprotobyname('tcp') in sandbox
  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = stdenv.lib.optionalString stdenv.isLinux ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  checkInputs = [ pytest_32 case ];
  propagatedBuildInputs = [ kombu billiard pytz anyjson amqp eventlet ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/celery/;
    description = "Distributed task queue";
    license = licenses.bsd3;
  };
}
