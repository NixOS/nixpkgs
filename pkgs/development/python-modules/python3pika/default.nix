{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, nose
, mock
, pyyaml
, unittest2
}:

buildPythonPackage rec {
  pname = "python3-pika";
  version = "0.9.14";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c3hifwvn04kvlja88iawf0awyz726jynwnpcb6gn7376b4nfch7";
  };

  # Unit tests adds dependencies on pyev, tornado and twisted (and twisted is disabled for Python 3)
  doCheck = false;

  buildInputs = [ nose mock pyyaml ];
  propagatedBuildInputs = [ unittest2 ];

  meta = with stdenv.lib; {
    homepage = https://pika.readthedocs.org/;
    description = "Pika Python AMQP Client Library";
    license = licenses.gpl2;
  };

}
