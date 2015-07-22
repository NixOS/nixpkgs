{ stdenv, fetchurl, libintlOrEmpty, zlib, gettext }:

stdenv.mkDerivation rec {
  name = "cracklib-2.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/cracklib/${name}.tar.gz";
    sha256 = "0n49prh5rffl33bxy8qf46cqm6mswdlqpmm6iqi490w0p6s6da7j";
  };

  buildInputs = [ libintlOrEmpty zlib gettext ];

  meta = with stdenv.lib; {
    homepage    = http://sourceforge.net/projects/cracklib;
    description = "A library for checking the strength of passwords";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
