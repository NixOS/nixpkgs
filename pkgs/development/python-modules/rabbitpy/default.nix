{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, nose
, pamqp
}:

buildPythonPackage rec {
  version = "0.26.2";
  pname = "rabbitpy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pgijv7mgxc4sm7p9s716dhl600l8isisxzyg4hz7ng1sk09p1w3";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ pamqp ];

  meta = with stdenv.lib; {
    description = "A pure python, thread-safe, minimalistic and pythonic RabbitMQ client library";
    homepage = https://pypi.python.org/pypi/rabbitpy;
    license = licenses.bsd3;
  };

}
