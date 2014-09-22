{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "readline-6.3p08";

  src = fetchurl {
    url = "mirror://gnu/readline/readline-6.3.tar.gz";
    sha256 = "0hzxr9jxqqx5sxsv9vmlxdnvlr9vi4ih1avjb869hbs6p5qn1fjn";
  };

  propagatedBuildInputs = [ncurses];

  patchFlags = "-p0";

  patches =
    [ ./link-against-ncurses.patch
      ./no-arch_only-6.3.patch
    ]
    ++
    (let
       patch = nr: sha256:
         fetchurl {
           url = "mirror://gnu/readline/readline-6.3-patches/readline63-${nr}";
           inherit sha256;
         };
     in
       import ./readline-6.3-patches.nix patch);

  # Don't run the native `strip' when cross-compiling.
  dontStrip = stdenv ? cross;

  meta = with stdenv.lib; {
    description = "Library for interactive line editing";

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

    license = licenses.gpl3Plus;

    maintainers = [ maintainers.ludo ];

    platforms = platforms.unix;
  };
}
