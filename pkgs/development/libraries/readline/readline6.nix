{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "readline-6.1";

  src = fetchurl {
    url = "mirror://gnu/readline/${name}.tar.gz";
    sha256 = "0sd97zqdh4fc0zzgzpskkczwa2fmb0s89qdyndb6vkbcq04gdjph";
  };

  propagatedBuildInputs = [ncurses];

  patchFlags = "-p0";
  patches =
    [ ./link-against-ncurses.patch ]
    ++
    (let
       patch = nr: sha256:
         fetchurl {
           url = "mirror://gnu/readline/${name}-patches/readline61-${nr}";
           inherit sha256;
         };
     in
       import ./readline-patches.nix patch);

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

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
