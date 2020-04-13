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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gqx9avb9nwgiyw5nz08bf99v9b0hvzr1pmqn9wbhd2hnsj6p9wz";
  };

  checkInputs = [ nose mock twisted tornado ];

  meta = with stdenv.lib; {
    description = "Pure-Python implementation of the AMQP 0-9-1 protocol";
    homepage = "https://pika.readthedocs.org";
    license = licenses.bsd3;
  };

}
