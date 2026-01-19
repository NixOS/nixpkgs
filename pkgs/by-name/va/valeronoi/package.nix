{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cgal,
  cmake,
  gpp,
  mpfr,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valeronoi";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ccoors";
    repo = "valeronoi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5KXVSIqWDkXnpO+qgBzFtbJb444RW8dIVXp8Y/aAOrk=";
  };

  buildInputs = [
    boost
    cgal
    gpp
    mpfr
  ]
  ++ (with qt6Packages; [
    qtbase
    qtimageformats
    qtsvg
  ]);

  nativeBuildInputs = [
    cmake
    qt6Packages.wrapQtAppsHook
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/ccoors/Valeronoi/";
    description = "WiFi mapping companion app for Valetudo";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      nova-madeline
      maeve
    ];
    mainProgram = "valeronoi";
  };
})
