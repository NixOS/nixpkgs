{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "libedit-20090405-3.0";
  
  src = fetchurl {
    url = http://www.thrysoee.dk/editline/libedit-20090405-3.0.tar.gz;
    sha256 = "1il68apydk6nnm30v8gn61vbi23ii571bixp7662j96xsivy7z5l";
  };
  
  propagatedBuildInputs = [ ncurses ];

  meta = {
    homepage = "http://www.thrysoee.dk/editline/";
    description = "A port of the NetBSD Editline library (libedit)";
  };
}
