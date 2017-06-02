{ stdenv, buildPythonPackage, fetchurl,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  name = "${pname}-${version}";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://pypi/c/channels/${name}.tar.gz";
    sha256 = "182war437i6wsxwf2v4szn8ig0nkpinpn4n27fxhh5q8w832hj93";
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
