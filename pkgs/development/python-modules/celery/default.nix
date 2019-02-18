{ stdenv, buildPythonPackage, fetchPypi, isPy37, fetchpatch, iana-etc, libredirect,
  pytest, case, kombu, billiard, pytz, anyjson, amqp, eventlet
}:

buildPythonPackage rec {
  pname = "celery";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y66rz7z8dfcgs3s0qxmdddlaq57bzbgxgfz896nbp14grkv9nkp";
  };

  # See https://github.com/celery/celery/issues/4500
  # TODO: Remove once upgraded to 4.3
  disabled = isPy37;

  patches = [
    # Skip test_RedisBackend.test_timeouts_in_url_coerced
    # See https://github.com/celery/celery/pull/4847
    (fetchpatch {
      url = https://github.com/celery/celery/commit/b2668607c909c61becd151905b4525190c19ff4a.patch;
      sha256 = "11w0z2ycyh8kccj4y69zb7bxppiipcwwigg6jn1q9yrcsvz170jq";
    })
    # Allow usage of a newer pytest version
    # See https://github.com/celery/celery/pull/4912
    (fetchpatch {
      url = https://github.com/celery/celery/commit/16f56fe6f84cac9f92affac3ad06a1f168a19798.patch;
      sha256 = "0vz68rl32m34k51nhs898jcfdbj5m7cszzxx0w0j3j1fhn1wq594";
    })
  ];

  postPatch = ''
    substituteInPlace requirements/test.txt --replace ",<3.9" ""
  '';

  # make /etc/protocols accessible to fix socket.getprotobyname('tcp') in sandbox
  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = stdenv.lib.optionalString stdenv.isLinux ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  checkInputs = [ pytest case ];
  propagatedBuildInputs = [ kombu billiard pytz anyjson amqp eventlet ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/celery/;
    description = "Distributed task queue";
    license = licenses.bsd3;
  };
}
