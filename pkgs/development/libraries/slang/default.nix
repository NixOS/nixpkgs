{ stdenv, fetchurl, ncurses, pcre, libpng, zlib, readline }:

stdenv.mkDerivation rec {
  name = "slang-2.3.0";
  src = fetchurl {
    url = "http://www.jedsoft.org/releases/slang/${name}.tar.gz";
    sha256 = "0aqd2cjabj6nhd4r3dc4vhqif2bf3dmqnrn2gj0xm4gqyfd177jy";
  };

  # Fix some wrong hardcoded paths
  preConfigure = ''
    sed -i -e "s|/usr/lib/terminfo|${ncurses}/lib/terminfo|" configure
    sed -i -e "s|/usr/lib/terminfo|${ncurses}/lib/terminfo|" src/sltermin.c
    sed -i -e "s|/bin/ln|ln|" src/Makefile.in
  '';
  configureFlags = "--with-png=${libpng} --with-z=${zlib} --with-pcre=${pcre} --with-readline=${readline}";
  buildInputs = [ncurses pcre libpng zlib readline];

  meta = {
    description = "A multi-platform programmer's library designed to allow a developer to create robust software";
    homepage = http://www.jedsoft.org/slang/;
    license = stdenv.lib.licenses.gpl2Plus;
    platform = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
