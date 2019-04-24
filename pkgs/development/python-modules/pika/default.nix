{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, mock
, twisted
, tornado
}:

buildPythonPackage rec {
  pname = "pika";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ba83d3daffccb92788d24facdab62a3db6aa03b8a6d709b03dc792d35c0dfe8";
  };

  # No tests in PyPI tarball
  doCheck = false;

  propagatedBuildInputs = [ twisted tornado ];
  checkInputs = [ nose mock ];

  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "Pure-Python implementation of the AMQP 0-9-1 protocol";
    homepage = https://pika.readthedocs.io/;
    license = licenses.bsd3;
  };

}
