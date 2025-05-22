{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  withQt ? true,
  libsForQt5,
  withCurses ? false,
  ncurses,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "12.4";
  pname = "textadept";

  src = fetchFromGitHub {
    name = "textadept11";
    owner = "orbitalquark";
    repo = "textadept";
    tag = "textadept_${finalAttrs.version}";
    hash = "sha256-nPgpQeBq5Stv2o0Ke4W2Ltnx6qLe5TIC5a8HSYVkmfI=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals withQt [ libsForQt5.wrapQtAppsHook ];

  buildInputs = lib.optionals withQt [ libsForQt5.qtbase ] ++ lib.optionals withCurses ncurses;

  cmakeFlags =
    lib.optional withQt [ "-DQT=ON" ]
    ++ lib.optional withCurses [
      "-DCURSES=ON"
      "-DQT=OFF"
    ];

  preConfigure =
    ''
      mkdir -p $PWD/build/_deps

    ''
    + lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: params: "ln -s ${fetchurl params} $PWD/build/_deps/${name}"
      ) (import ./deps.nix)
    );

  meta = {
    description = "Extensible text editor based on Scintilla with Lua scripting";
    homepage = "http://foicica.com/textadept";
    downloadPage = "https://github.com/orbitalquark/textadept";
    changelog = "https://github.com/orbitalquark/textadept/releases/tag/textadept_${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      raskin
      mirrexagon
      arcuru
    ];
    platforms = lib.platforms.linux;
    mainProgram = "textadept";
  };
})
