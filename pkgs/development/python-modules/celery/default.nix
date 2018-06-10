{ stdenv, buildPythonPackage, fetchPypi, iana-etc, libredirect,
  pytest, case, kombu, billiard, pytz, anyjson, amqp, eventlet
}:

buildPythonPackage rec {
  pname = "celery";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dcb0s6kdcd3vc9pwvazngppkdbhwpmpjmghq6rifsld34q3gzvp";
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
