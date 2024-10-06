{ lib, stdenv
, fetchpatch, fetchurl
, updateAutotoolsGnuConfigScriptsHook
, ncurses, termcap
, curses-library ?
    if stdenv.hostPlatform.isWindows
    then termcap
    else ncurses
}:

stdenv.mkDerivation rec {
  pname = "readline";
  version = "8.2p${toString (builtins.length upstreamPatches)}";

  src = fetchurl {
    url = "mirror://gnu/readline/readline-${meta.branch}.tar.gz";
    sha256 = "sha256-P+txcfFqhO6CyhijbXub4QmlLAT0kqBTMx19EJUAfDU=";
  };

  outputs = [ "out" "dev" "man" "doc" "info" ];

  strictDeps = true;
  propagatedBuildInputs = [ curses-library ];
  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];

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

  patches = upstreamPatches ++ [
    ./no-arch_only-8.2.patch
    (fetchpatch {
      name = "0001-sigwinch.patch";
      url = "https://github.com/msys2/MINGW-packages/raw/b81ea935fc1d885134d4ff5463f639f10e34a29e/mingw-w64-readline/0001-sigwinch.patch";
      stripLen = 1;
      hash = "sha256-sFK6EJrSNl0KLWqFv5zBXaQRuiQoYIZVoZfa8BZqfKA=";
    })
    (fetchpatch {
      name = "0002-event-hook.patch";
      url = "https://github.com/msys2/MINGW-packages/raw/b81ea935fc1d885134d4ff5463f639f10e34a29e/mingw-w64-readline/0002-event-hook.patch";
      stripLen = 1;
      hash = "sha256-zJo/7Id0mizyBCYFeGGoZj3r+qPOcdYZvjVz5nc+02k=";
    })
    (fetchpatch {
      name = "0003-fd_set.patch";
      url = "https://github.com/msys2/MINGW-packages/raw/b81ea935fc1d885134d4ff5463f639f10e34a29e/mingw-w64-readline/0003-fd_set.patch";
      stripLen = 1;
      hash = "sha256-UiaXZRPjKecpSaflBMCphI2kqOlcz1JkymlCrtpMng4=";
    })
    (fetchpatch {
      name = "0004-locale.patch";
      url = "https://github.com/msys2/MINGW-packages/raw/b81ea935fc1d885134d4ff5463f639f10e34a29e/mingw-w64-readline/0004-locale.patch";
      stripLen = 1;
      hash = "sha256-dk4343KP4EWXdRRCs8GRQlBgJFgu1rd79RfjwFD/nJc=";
    })
  ] ++ lib.optionals (curses-library.pname == "ncurses") [
    ./link-against-ncurses.patch
  ];

  enableParallelBuilding = true;

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

    platforms = platforms.unix ++ platforms.windows;
    branch = "8.2";
  };
}
