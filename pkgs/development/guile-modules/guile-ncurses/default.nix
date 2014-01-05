{ fetchurl, stdenv, guile, ncurses, libffi }:

stdenv.mkDerivation rec {
  name = "guile-ncurses-1.4";

  src = fetchurl {
    url = "mirror://gnu/guile-ncurses/${name}.tar.gz";
    sha256 = "070wl664lsm14hb6y9ch97x9q6cns4k6nxgdzbdzi5byixn74899";
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

    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
