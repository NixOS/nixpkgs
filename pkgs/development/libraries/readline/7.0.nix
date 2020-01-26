{ fetchurl, stdenv, ncurses
}:

stdenv.mkDerivation rec {
  pname = "readline";
  version = "7.0p${toString (builtins.length upstreamPatches)}";

  src = fetchurl {
    url = "mirror://gnu/readline/readline-${meta.branch}.tar.gz";
    sha256 = "0d13sg9ksf982rrrmv5mb6a2p4ys9rvg9r71d6il0vr8hmql63bm";
  };

  outputs = [ "out" "dev" "man" "doc" "info" ];

  propagatedBuildInputs = [ncurses];

  patchFlags = [ "-p0" ];

  upstreamPatches =
    (let
       patch = nr: sha256:
         fetchurl {
           url = "mirror://gnu/readline/readline-${meta.branch}-patches/readline70-${nr}";
           inherit sha256;
         };
     in
       import ./readline-7.0-patches.nix patch);

  patches =
    [ ./link-against-ncurses.patch
      ./no-arch_only-6.3.patch
    ]
    ++ upstreamPatches;

  # Don't run the native `strip' when cross-compiling.
  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;
  bash_cv_func_sigsetjmp = if stdenv.isCygwin then "missing" else null;

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

      The history facilities are also placed into a separate library,
      the History library, as part of the build process.  The History
      library may be used without Readline in applications which
      desire its capabilities.
    '';

    homepage = https://savannah.gnu.org/projects/readline/;

    license = licenses.gpl3Plus;

    maintainers = [ maintainers.vanschelven ];

    platforms = platforms.unix;
    branch = "7.0";
  };
}
