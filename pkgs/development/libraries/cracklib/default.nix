{ stdenv, fetchurl, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "cracklib-2.8.16";

  src = fetchurl {
    url = "mirror://sourceforge/cracklib/${name}.tar.gz";
    sha256 = "1g3mchdvra9nihxlkl3rdz96as3xnfw5m59hmr5k17l7qa9a8fpw";
  };

  buildInputs = libintlOrEmpty;

  meta = with stdenv.lib; {
    homepage    = http://sourceforge.net/projects/cracklib;
    description = "A library for checking the strength of passwords";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
