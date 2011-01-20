{ fetchurl, stdenv, guile, ncurses }:

stdenv.mkDerivation rec {
  name = "guile-ncurses-1.2";

  src = fetchurl {
    url = "mirror://gnu/guile-ncurses/${name}.tar.gz";
    sha256 = "038jfi14wdcpq87bpyff2b5mb9mr0garsa3dypwwd29ah6h1x00i";
  };

  buildInputs = [ guile ncurses ];

  preConfigure =
    '' configureFlags="$configureFlags --with-guilesitedir=$out/share/guile/site" '';

  preCheck = '' export TERM=xterm '';
  doCheck = false;  # FIXME: Hard to test non-interactively.

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
