{
  fetchurl,
  lib,
  stdenv,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "readline";
  version = "7.0p${toString (builtins.length finalAttrs.upstreamPatches)}";

  src = fetchurl {
    url = "mirror://gnu/readline/readline-${finalAttrs.meta.branch}.tar.gz";
    hash = "sha256-dQ1DcYUob0CjaeHk9HZO2pMrlFm17JpzFig5PdPTIzQ=";
  };

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
    "info"
  ];

  strictDeps = true;
  propagatedBuildInputs = [ ncurses ];

  patchFlags = [ "-p0" ];

  upstreamPatches = (
    let
      patch =
        nr: sha256:
        fetchurl {
          url = "mirror://gnu/readline/readline-${finalAttrs.meta.branch}-patches/readline70-${nr}";
          inherit sha256;
        };
    in
    import ./readline-7.0-patches.nix patch
  );

  patches = [
    ./link-against-ncurses.patch
    ./no-arch_only-6.3.patch
  ]
  ++ finalAttrs.upstreamPatches;

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-std=gnu17";
  };

  __structuredAttrs = true;

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

    homepage = "https://savannah.gnu.org/projects/readline/";

    license = lib.licenses.gpl3Plus;

    maintainers = [ ];

    platforms = lib.platforms.unix;
    branch = "7.0";
  };
})
