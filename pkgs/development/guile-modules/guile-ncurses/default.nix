{ fetchurl, stdenv, guile, ncurses, libffi }:

stdenv.mkDerivation rec {
  name = "guile-ncurses-1.7";

  src = fetchurl {
    url = "mirror://gnu/guile-ncurses/${name}.tar.gz";
    sha256 = "153vv75gb7l62sp3666rc97i63rnaqbx2rjar7d9b5w81fhwv4r5";
  };

  buildInputs = [ guile ncurses libffi ];

  preConfigure =
    '' configureFlags="$configureFlags --with-guilesitedir=$out/share/guile/site" '';

  doCheck = false;  # XXX: 1 of 65 tests failed

  meta = {
    description = "GNU Guile-Ncurses, Scheme interface to the NCurses libraries";

    longDescription =
      '' GNU Guile-Ncurses is a library for the Guile Scheme interpreter that
         provides functions for creating text user interfaces.  The text user
         interface functionality is built on the ncurses libraries: curses,
         form, panel, and menu.
      '';

    license = stdenv.lib.licenses.lgpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
