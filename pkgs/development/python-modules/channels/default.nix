{ stdenv, buildPythonPackage, fetchurl,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  name = "${pname}-${version}";
  version = "1.1.5";

  src = fetchurl {
    url = "mirror://pypi/c/channels/${name}.tar.gz";
    sha256 = "a9005bcb6104d26a7f93d9cf012bcf6765a0ff444a449ac68d6e1f16721f8ed3";
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
