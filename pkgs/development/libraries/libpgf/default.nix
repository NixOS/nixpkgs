{ stdenv, fetchurl, autoconf, automake, libtool, dos2unix }:

with stdenv.lib;

let
  version = "6.14.12";
in
stdenv.mkDerivation {
  name = "libpgf-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libpgf/libpgf-src-${version}.tar.gz";
    sha256 = "1ssqjbh6l5jc04f67n47m9bqcigl46c6lgyabyi6cabnh1frk9dx";
  };

  buildInputs = [ autoconf automake libtool dos2unix ];

  preConfigure = "dos2unix configure.ac; sh autogen.sh";

# configureFlags = optional static "--enable-static --disable-shared";

  meta = {
    homepage = http://www.libpgf.org/;
    description = "Progressive Graphics Format";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
