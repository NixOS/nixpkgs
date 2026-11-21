{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "13.0";
  pname = "textadept";

  src = fetchFromGitHub {
    owner = "orbitalquark";
    repo = "textadept";
    tag = "textadept_${finalAttrs.version}";
    hash = "sha256-IV+wlL2YgC7uPSweJZx7w2DKd/wYAf8efanQ11ESOVI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
  ];

  cmakeFlags = [
    "-DQT=ON"
    "-DCURSES=OFF"
    "-DGTK2=OFF"
    "-DGTK3=OFF"
  ];

  qtWrapperArgs = [
    "--set"
    "QT_QPA_PLATFORMTHEME"
    "generic"
  ];

  preConfigure = ''
    rm -rf "$PWD/build/_deps"
    mkdir -p "$PWD/build/_deps"

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: params: "ln -s ${fetchurl params} \"$PWD/build/_deps/${name}\"") (
        import ./deps.nix
      )
    )}
  '';

  doCheck = false;

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
