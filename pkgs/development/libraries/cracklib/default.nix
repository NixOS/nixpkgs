{ stdenv, fetchurl, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "cracklib-2.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/cracklib/${name}.tar.gz";
    sha256 = "0mni2sz7350d4acs7gdl8nilfmnb8qhcvmxnpf6dr5wsag10b2a0";
  };

  buildInputs = libintlOrEmpty;

  meta = with stdenv.lib; {
    homepage    = http://sourceforge.net/projects/cracklib;
    description = "A library for checking the strength of passwords";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
