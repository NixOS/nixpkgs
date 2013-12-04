{ fetchurl, stdenv, guile, ncurses, libffi }:

stdenv.mkDerivation rec {
  name = "guile-ncurses-1.3";

  src = fetchurl {
    url = "mirror://gnu/guile-ncurses/${name}.tar.gz";
    sha256 = "0chvfjrlmg99db98ra9vzwjmbypqx7d4ssm8q0kvzi0n0p9irszi";
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
