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
  version = "3.9.9";

  src = fetchurl {
    url = "https://ratrabbit.nl/downloads/xsnow/xsnow-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-rm4j6xGSnD/ZIMMDR0Gy/+YYDSLacb59F2JaSJja084=";
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
    # last successful hydra build on darwin and aarch64-linux were in 2024
    broken =
      stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
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
