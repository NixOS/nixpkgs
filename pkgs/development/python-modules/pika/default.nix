{ lib
, buildPythonPackage
, fetchPypi
, nose
, mock
, twisted
, tornado
}:

buildPythonPackage rec {
  pname = "pika";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f023d6ac581086b124190cb3dc81dd581a149d216fa4540ac34f9be1e3970b89";
  };

  checkInputs = [ nose mock twisted tornado ];

  meta = with lib; {
    description = "Pure-Python implementation of the AMQP 0-9-1 protocol";
    homepage = "https://pika.readthedocs.org";
    license = licenses.bsd3;
  };

}
