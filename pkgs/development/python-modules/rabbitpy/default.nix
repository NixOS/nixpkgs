{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, nose
, pamqp
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "rabbitpy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54d33746d0c6a686417cd354346803945df0740b39fb92842d259387100db126";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ pamqp ];

  meta = with stdenv.lib; {
    description = "A pure python, thread-safe, minimalistic and pythonic RabbitMQ client library";
    homepage = https://pypi.python.org/pypi/rabbitpy;
    license = licenses.bsd3;
  };

}
