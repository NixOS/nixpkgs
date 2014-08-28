{ fetchzip, stdenv, ncurses }:

stdenv.mkDerivation (rec {
  name = "readline-6.3p08";

  src = fetchzip {
    #url = "mirror://gnu/readline/${name}.tar.gz";
    url = "http://git.savannah.gnu.org/cgit/readline.git/snapshot/"
      + "readline-a73b98f779b388a5d0624e02e8bb187246e3e396.tar.gz";
    sha256 = "19ji3wrv4fs79fd0nkacjy9q94pvy2cm66yb3aqysahg0cbrz5l1";
  };

  propagatedBuildInputs = [ncurses];

  patchFlags = "-p0";

  patches =
    [ ./link-against-ncurses.patch
      ./no-arch_only-6.3.patch
    ];

  meta = with stdenv.lib; {
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

    license = licenses.gpl3Plus;

    maintainers = [ maintainers.ludo ];

    platforms = platforms.unix;
  };
}

//

# Don't run the native `strip' when cross-compiling.
(if (stdenv ? cross)
 then { dontStrip = true; }
 else { }))
