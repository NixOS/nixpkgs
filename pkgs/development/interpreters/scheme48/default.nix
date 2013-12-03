{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "scheme48-1.9";

  meta = {
    homepage = http://s48.org/;
    description = "Scheme 48";
  };

  src = fetchurl {
    url = http://s48.org/1.9/scheme48-1.9.tgz;
    md5 = "b4c20057f92191d05a61fac1372878ad";
  };
}
