{ stdenv, fetchurl, ncurses, pcre, libpng, zlib, readline, libiconv }:

stdenv.mkDerivation rec {
  name = "slang-2.3.1a";
  src = fetchurl {
    url = "http://www.jedsoft.org/releases/slang/${name}.tar.bz2";
    sha256 = "0dlcy0hn0j6cj9qj5x6hpb0axifnvzzmv5jqq0wq14fygw0c7w2l";
  };

  outputs = [ "out" "dev" "doc" ];

  # Fix some wrong hardcoded paths
  preConfigure = ''
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" configure
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" src/sltermin.c
    sed -i -e "s|/bin/ln|ln|" src/Makefile.in
    sed -i -e "s|-ltermcap|-lncurses|" ./configure
  '';
  configureFlags = "--with-png=${libpng.dev} --with-z=${zlib.dev} --with-pcre=${pcre.dev} --with-readline=${readline.dev}";
  buildInputs = [ pcre libpng zlib readline ] ++ stdenv.lib.optionals (stdenv.isDarwin) [ libiconv ];
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
