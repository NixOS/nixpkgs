{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  version = "2.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48f97f1801e0a8da6d01430d16d4ed8bd460d4ec3130c66075fb94b12bb30a67";
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
