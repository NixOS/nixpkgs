{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "readline-6.0";

  src = fetchurl {
    url = "mirror://gnu/readline/${name}.tar.gz";
    sha256 = "1pn13j6f9376kwki69050x3zh62yb1w31l37rws5nwr5q02xk68i";
  };

  propagatedBuildInputs = [ncurses];
  configureFlags = "--enable-shared --disable-static";
  patches = stdenv.lib.optional stdenv.isDarwin ./shobj-darwin.patch;

  meta = {
    description = "GNU Readline, a library for interactive line editing";

    longDescription = ''
      The GNU Readline library provides a set of functions for use by
      applications that allow users to edit command lines as they are
      typed in.  Both Emacs and vi editing modes are available.  The
      Readline library includes additional functions to maintain a
      list of previously-entered command lines, to recall and perhaps
      reedit those lines, and perform csh-like history expansion on
      previous commands.

      The history facilites are also placed into a separate library,
      the History library, as part of the build process.  The History
      library may be used without Readline in applications which
      desire its capabilities.
    '';

    homepage = http://savannah.gnu.org/projects/readline/;

    license = "GPLv3+";
  };
}
