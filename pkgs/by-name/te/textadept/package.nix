{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  withQt ? true,
  qt6,
  withCurses ? false,
  ncurses,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "12.9";
  pname = "textadept";

  src = fetchFromGitHub {
    owner = "orbitalquark";
    repo = "textadept";
    tag = "textadept_${finalAttrs.version}";
    hash = "sha256-vpBmDcnaHdpYZIfcy482G4NGor+64Dh1tzryb8JJ+c8=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals withQt [
    qt6.wrapQtAppsHook
  ];

  buildInputs =
    lib.optionals withQt [
      qt6.qtbase
      qt6.qt5compat
    ]
    ++ lib.optionals withCurses ncurses;

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
      mikecm
    ];
    platforms = lib.platforms.linux;
    mainProgram = "textadept";
  };
})
