{ stdenv, buildPythonPackage, fetchurl,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  name = "${pname}-${version}";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://pypi/c/channels/${name}.tar.gz";
    sha256 = "44ab9a1f610ecc9ac25d5f90e7a44f49b18de28a05a26fe34e935af257f1eefe";
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
