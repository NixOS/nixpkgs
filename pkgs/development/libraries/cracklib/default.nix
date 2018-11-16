{ stdenv, fetchurl, zlib, gettext }:

stdenv.mkDerivation rec {
  name = "cracklib-2.9.6";

  src = fetchurl {
    url = "https://github.com/cracklib/cracklib/releases/download/${name}/${name}.tar.gz";
    sha256 = "0hrkb0prf7n92w6rxgq0ilzkk6rkhpys2cfqkrbzswp27na7dkqp";
  };

  buildInputs = [ zlib gettext ];

  meta = with stdenv.lib; {
    homepage    = https://github.com/cracklib/cracklib;
    description = "A library for checking the strength of passwords";
    license = licenses.lgpl21; # Different license for the wordlist: http://www.openwall.com/wordlists
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
