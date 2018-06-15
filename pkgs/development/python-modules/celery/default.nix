{ stdenv, buildPythonPackage, fetchPypi, iana-etc, libredirect,
  pytest, case, kombu, billiard, pytz, anyjson, amqp, eventlet
}:

buildPythonPackage rec {
  pname = "celery";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1f2a3359bdbdfb344edce98b8e891f5fe64f8a11c5a45538ec20ac237c971f5";
  };

  # make /etc/protocols accessible to fix socket.getprotobyname('tcp') in sandbox
  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = stdenv.lib.optionalString stdenv.isLinux ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  buildInputs = [ pytest case ];
  propagatedBuildInputs = [ kombu billiard pytz anyjson amqp eventlet ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/celery/;
    description = "Distributed task queue";
    license = licenses.bsd3;
  };
}
