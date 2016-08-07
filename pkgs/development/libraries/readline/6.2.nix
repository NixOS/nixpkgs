{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation (rec {
  name = "readline-6.2";

  src = fetchurl {
    url = "mirror://gnu/readline/${name}.tar.gz";
    sha256 = "10ckm2bd2rkxhvdmj7nmbsylmihw0abwcsnxf8y27305183rd9kr";
  };

  propagatedBuildInputs = [ncurses];

  patchFlags = "-p0";
  patches =
    [ ./link-against-ncurses.patch
      ./no-arch_only.patch
      ./clang.patch
    ]
    ++
    (let
       patch = nr: sha256:
         fetchurl {
           url = "mirror://gnu/readline/${name}-patches/readline62-${nr}";
           inherit sha256;
         };
     in
       import ./readline-6.2-patches.nix patch);

  meta = {
    description = "Library for interactive line editing";

    longDescription = ''
      The GNU Readline library provides a set of functions for use by
      applications that allow users to edit command lines as they are
      typed in.  Both Emacs and vi editing modes are available.  The
      Readline library includes additional functions to maintain a
      list of previously-entered command lines, to recall and perhaps
      reedit those lines, and perform csh-like history expansion on
      previous commands.

      The history facilities are also placed into a separate library,
      the History library, as part of the build process.  The History
      library may be used without Readline in applications which
      desire its capabilities.
    '';

    homepage = http://savannah.gnu.org/projects/readline/;

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    branch = "6.2";
    platforms = stdenv.lib.platforms.unix;
  };
}

//

# Don't run the native `strip' when cross-compiling.
(if (stdenv ? cross)
 then { dontStrip = true; }
 else { }))
