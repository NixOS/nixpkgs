{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  name = "${pname}-${version}";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gsy3hwn1vd709jkw8ay44qrm6aw7qggr312z8xwzq0x4ihjda02";
  };

  # Files are missing in the distribution
  doCheck = false;

  propagatedBuildInputs = [ asgiref django daphne ];

  meta = with stdenv.lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    license = licenses.bsd3;
    homepage = https://github.com/django/channels;
  };
}
