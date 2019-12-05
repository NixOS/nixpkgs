{ stdenv, fetchurl, ncurses, pcre, libpng, zlib, readline, libiconv }:

stdenv.mkDerivation rec {
  name = "slang-2.3.2";
  src = fetchurl {
    url = "https://www.jedsoft.org/releases/slang/${name}.tar.bz2";
    sha256 = "06p379fqn6w38rdpqi98irxi2bf4llb0rja3dlgkqz7nqh7kp7pw";
  };

  outputs = [ "out" "dev" "man" "doc" ];

  patches = [ ./terminfo-dirs.patch ];

  # Fix some wrong hardcoded paths
  preConfigure = ''
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" configure
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" src/sltermin.c
    sed -i -e "s|/bin/ln|ln|" src/Makefile.in
    sed -i -e "s|-ltermcap|-lncurses|" ./configure
  '';

  configureFlags = [
    "--with-png=${libpng.dev}"
    "--with-z=${zlib.dev}"
    "--with-pcre=${pcre.dev}"
    "--with-readline=${readline.dev}"
  ];

  buildInputs = [
    pcre libpng zlib readline
  ] ++ stdenv.lib.optionals (stdenv.isDarwin) [ libiconv ];

  propagatedBuildInputs = [ ncurses ];

  # slang 2.3.2 does not support parallel building
  enableParallelBuilding = false;

  postInstall = ''
    find "$out"/lib/ -name '*.so' -exec chmod +x "{}" \;
    sed '/^Libs:/s/$/ -lncurses/' -i "$dev"/lib/pkgconfig/slang.pc
  '';

  meta = with stdenv.lib; {
    description = "A multi-platform programmer's library designed to allow a developer to create robust software";
    homepage = http://www.jedsoft.org/slang/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
