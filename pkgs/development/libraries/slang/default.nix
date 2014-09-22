{ stdenv, fetchurl, ncurses, pcre, libpng, zlib, readline }:

stdenv.mkDerivation rec {
  name = "slang-2.3.0";
  src = fetchurl {
    url = "ftp://ftp.fu-berlin.de/pub/unix/misc/slang/v2.2/${name}.tar.bz2";
    sha256 = "0ab1j8pb3r84c5wqwadh3d5akwd5mwwv6fah58hxiq251w328lpr";
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
