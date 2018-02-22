{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  name = "${pname}-${version}";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d41e0f2aa40f9755f36c2c1dd83748b6793732190d577922e06294a3b37fd92";
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
