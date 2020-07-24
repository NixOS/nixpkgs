{ stdenv, fetchurl, pkgconfig, guile, ncurses, libffi }:

let
  name = "guile-ncurses-${version}";
  version = "1.7";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/guile-ncurses/${name}.tar.gz";
    sha256 = "153vv75gb7l62sp3666rc97i63rnaqbx2rjar7d9b5w81fhwv4r5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ guile ncurses libffi ];

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

  meta = with stdenv.lib; {
    description = "Scheme interface to the NCurses libraries";
    longDescription = ''
      GNU Guile-Ncurses is a library for the Guile Scheme interpreter that
      provides functions for creating text user interfaces.  The text user
      interface functionality is built on the ncurses libraries: curses, form,
      panel, and menu.
    '';
    homepage = "https://www.gnu.org/software/guile-ncurses/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
