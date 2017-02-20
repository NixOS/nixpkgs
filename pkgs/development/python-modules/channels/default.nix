{ stdenv, buildPythonPackage, fetchurl,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  name = "channels-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "mirror://pypi/c/channels/${name}.tar.gz";
    sha256 = "1bwlqnfc27p1qnjmdl8jnr941gpl8ggnxxfy8anh9qgmg20q9pfd";
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
