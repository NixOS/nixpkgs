{ lib
, stdenv
, fetchurl
, pkg-config
, guile
, libffi
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "guile-ncurses";
  version = "1.7";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-JZPNoQuIl5XayUpm0RdWNg8TT2LZGDOuFoae9crZe5Q=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    guile
    libffi
    ncurses
  ];

  preConfigure = ''
    configureFlags="$configureFlags --with-guilesitedir=$out/share/guile/site"
  '';

  postFixup = ''
    for f in $out/share/guile/site/ncurses/**.scm; do \
      substituteInPlace $f \
        --replace "libguile-ncurses" "$out/lib/libguile-ncurses"; \
    done
  '';

  # XXX: 1 of 65 tests failed.
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/guile-ncurses/";
    description = "Scheme interface to the NCurses libraries";
    longDescription = ''
      GNU Guile-Ncurses is a library for the Guile Scheme interpreter that
      provides functions for creating text user interfaces.  The text user
      interface functionality is built on the ncurses libraries: curses, form,
      panel, and menu.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
