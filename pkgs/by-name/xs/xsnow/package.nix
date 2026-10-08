{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  wrapGAppsHook3,
  gtk3-x11,
  libxt,
  libxtst,
  libxpm,
  libx11,
  libxkbcommon,
  gsl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xsnow";
  version = "3.9.0";

  src = fetchurl {
    url = "https://ratrabbit.nl/downloads/xsnow/xsnow-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-PMZsxZUmVHZwU6+KBPMq8sjyt42jlrXazgk7DGc9bvo=";
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
    libx11
    libxpm
    libxt
    libxtst
  ];

  makeFlags = [ "gamesdir=$(out)/bin" ];

  enableParallelBuilding = true;

  meta = {
    description = "X-windows application that will let it snow on the root, in between and on windows";
    mainProgram = "xsnow";
    homepage = "https://ratrabbit.nl/ratrabbit/xsnow/";
    changelog = "https://ratrabbit.nl/ratrabbit/xsnow/changelog/index.html";
    downloadPage = "https://ratrabbit.nl/ratrabbit/xsnow/downloads/index.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      robberer
      griffi-gh
    ];
    platforms = lib.platforms.unix;
  };
})
