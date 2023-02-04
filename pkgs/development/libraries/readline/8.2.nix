{ fetchurl, stdenv, lib, ncurses
}:

stdenv.mkDerivation rec {
  pname = "readline";
  version = "8.2p${toString (builtins.length upstreamPatches)}";

  src = fetchurl {
    url = "mirror://gnu/readline/readline-${meta.branch}.tar.gz";
    sha256 = "sha256-P+txcfFqhO6CyhijbXub4QmlLAT0kqBTMx19EJUAfDU=";
  };

  outputs = [ "out" "dev" "man" "doc" "info" ];

  propagatedBuildInputs = [ncurses];

  patchFlags = [ "-p0" ];

  upstreamPatches =
    (let
       patch = nr: sha256:
         fetchurl {
           url = "mirror://gnu/readline/readline-${meta.branch}-patches/readline82-${nr}";
           inherit sha256;
         };
     in
       import ./readline-8.2-patches.nix patch);

  patches =
    [ ./link-against-ncurses.patch
      ./no-arch_only-8.2.patch
    ]
    ++ upstreamPatches;

  meta = with lib; {
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

    homepage = "https://savannah.gnu.org/projects/readline/";

    license = licenses.gpl3Plus;

    maintainers = with maintainers; [ dtzWill ];

    platforms = platforms.unix;
    branch = "8.2";
  };
}
