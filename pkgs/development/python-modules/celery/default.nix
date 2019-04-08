{ stdenv, buildPythonPackage, fetchPypi, isPy37, fetchpatch, iana-etc, libredirect
, case, pytest, boto3, moto, kombu, billiard, pytz, anyjson, amqp, eventlet
}:

buildPythonPackage rec {
  pname = "celery";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c4532aa683f170f40bd76f928b70bc06ff171a959e06e71bf35f2f9d6031ef9";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "pytest>=4.3.1,<4.4.0" pytest
  '';

  # make /etc/protocols accessible to fix socket.getprotobyname('tcp') in sandbox
  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = stdenv.lib.optionalString stdenv.isLinux ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  checkInputs = [ case pytest boto3 moto ];
  propagatedBuildInputs = [ kombu billiard pytz anyjson amqp eventlet ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/celery/;
    description = "Distributed task queue";
    license = licenses.bsd3;
  };
}
