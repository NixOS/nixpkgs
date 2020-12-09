{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f50a6e79757a64c1e45e95e144a2ac5f1e99ee44a0718ab182c501f5e5abd268";
  };

  # Files are missing in the distribution
  doCheck = false;

  propagatedBuildInputs = [ asgiref django daphne ];

  meta = with stdenv.lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    license = licenses.bsd3;
    homepage = "https://github.com/django/channels";
  };
}
