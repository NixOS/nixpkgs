{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08e756406d7165cb32f6fc3090c0643f41ca9f7e0f7fada0b31194662f20f414";
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
