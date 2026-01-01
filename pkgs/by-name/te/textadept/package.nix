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
<<<<<<< HEAD
  version = "12.9";
=======
  version = "12.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "textadept";

  src = fetchFromGitHub {
    owner = "orbitalquark";
    repo = "textadept";
    tag = "textadept_${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-vpBmDcnaHdpYZIfcy482G4NGor+64Dh1tzryb8JJ+c8=";
=======
    hash = "sha256-ba5YSZaWGGEFFAbHNNXv2/a4dWrG/o5mTySCmlPauWs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals withQt [ libsForQt5.wrapQtAppsHook ];

  buildInputs = lib.optionals withQt [ libsForQt5.qtbase ] ++ lib.optionals withCurses ncurses;

  cmakeFlags =
    lib.optional withQt [ "-DQT=ON" ]
    ++ lib.optional withCurses [
      "-DCURSES=ON"
      "-DQT=OFF"
    ];

  preConfigure = ''
    mkdir -p $PWD/build/_deps

  ''
  + lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: params: "ln -s ${fetchurl params} $PWD/build/_deps/${name}") (
      import ./deps.nix
    )
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
