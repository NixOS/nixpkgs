{ stdenv, fetchurl, ncurses, pcre, libpng, zlib, readline }:

stdenv.mkDerivation rec {
  name = "slang-2.3.0";
  src = fetchurl {
    url = "http://www.jedsoft.org/releases/slang/${name}.tar.gz";
    sha256 = "0aqd2cjabj6nhd4r3dc4vhqif2bf3dmqnrn2gj0xm4gqyfd177jy";
  };

  outputs = [ "dev" "out" "doc" ];

  # Fix some wrong hardcoded paths
  preConfigure = ''
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" configure
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" src/sltermin.c
    sed -i -e "s|/bin/ln|ln|" src/Makefile.in
    sed -i -e "s|-ltermcap|-lncurses|" ./configure
  '';
  configureFlags = "--with-png=${libpng.dev} --with-z=${zlib.dev} --with-pcre=${pcre.dev} --with-readline=${readline.dev}";
  buildInputs = [ pcre libpng zlib readline ];
  propagatedBuildInputs = [ ncurses ];

  postInstall = ''
    find "$out"/lib/ -name '*.so' -exec chmod +x "{}" \;
    sed '/^Libs:/s/$/ -lncurses/' -i "$dev"/lib/pkgconfig/slang.pc
  '';

  meta = with stdenv.lib; {
    description = "A multi-platform programmer's library designed to allow a developer to create robust software";
    homepage = http://www.jedsoft.org/slang/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.fuuzetsu ];
  };
}
