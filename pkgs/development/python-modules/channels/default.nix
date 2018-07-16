{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "173441ccf2ac3a93c3b4f86135db301cbe95be58f5815c1e071f2e7154c192a2";
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
