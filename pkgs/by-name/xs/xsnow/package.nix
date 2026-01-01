{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  wrapGAppsHook3,
  gtk3-x11,
  xorg,
  libxkbcommon,
  gsl,
}:
stdenv.mkDerivation rec {
  pname = "xsnow";
<<<<<<< HEAD
  version = "3.9.0";

  src = fetchurl {
    url = "https://ratrabbit.nl/downloads/xsnow/xsnow-${version}.tar.gz";
    sha256 = "sha256-PMZsxZUmVHZwU6+KBPMq8sjyt42jlrXazgk7DGc9bvo=";
=======
  version = "3.8.5";

  src = fetchurl {
    url = "https://ratrabbit.nl/downloads/xsnow/xsnow-${version}.tar.gz";
    sha256 = "sha256-NkoD/oMxdJwnx9QCBM8dwFOTPg7YzOZLnNiEOQt36cU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3-x11
    libxkbcommon
    libxml2
    gsl
  ]
  ++ (with xorg; [
    libX11
    libXpm
    libXt
    libXtst
  ]);

  makeFlags = [ "gamesdir=$(out)/bin" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "X-windows application that will let it snow on the root, in between and on windows";
    mainProgram = "xsnow";
    homepage = "https://ratrabbit.nl/ratrabbit/xsnow/";
    changelog = "https://ratrabbit.nl/ratrabbit/xsnow/changelog/index.html";
    downloadPage = "https://ratrabbit.nl/ratrabbit/xsnow/downloads/index.html";
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      robberer
      griffi-gh
    ];
    platforms = lib.platforms.unix;
=======
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      robberer
      griffi-gh
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
