{stdenv, fetchurl, ncurses, pcre, libpng, zlib, readline}:

stdenv.mkDerivation {
  name = "slang-2.2.1";
  src = fetchurl {
    url = ftp://ftp.fu-berlin.de/pub/unix/misc/slang/v2.2/slang-2.2.1.tar.bz2;
    sha256 = "1qgfg6i5lzmw8j9aqd8pgz3vnhn80giij9bpgm5r3gmna2h0rzfj";
  };
  # Fix some wrong hardcoded paths
  preConfigure = ''
    sed -i -e "s|/usr/lib/terminfo|${ncurses}/lib/terminfo|" configure
    sed -i -e "s|/usr/lib/terminfo|${ncurses}/lib/terminfo|" src/sltermin.c    
    sed -i -e "s|/bin/ln|ln|" src/Makefile.in
  '';
  configureFlags = "--with-png=${libpng} --with-z=${zlib} --with-pcre=${pcre} --with-readline=${readline}";
  buildInputs = [ncurses pcre libpng zlib readline];
}
