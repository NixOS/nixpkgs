{
  lib,
  boost,
  fetchFromGitHub,
  qt5,
  stdenv,
}:

let
  inherit (qt5) qmake wrapQtAppsHook;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zegrapher";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "AdelKS";
    repo = "ZeGrapher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OSQXm0gDI1zM2MBM4iiY43dthJcAZJkprklolsNMEvk=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
  ];

  strictDeps = true;

  meta = {
    homepage = "https://zegrapher.com/en/";
    description = "Open source math plotter";
    longDescription = ''
      An open source, free and easy to use math plotter. It can plot functions,
      sequences, parametric equations and data on the plane.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "ZeGrapher";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
