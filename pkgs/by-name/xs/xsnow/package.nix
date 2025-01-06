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
  version = "3.7.9";

  src = fetchurl {
    url = "https://ratrabbit.nl/downloads/xsnow/xsnow-${version}.tar.gz";
    sha256 = "sha256-DEzQblUfm2kd0I21sUwO3EVUm/WHnOk7T6iMgo3+EAY=";
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
  ] ++ (with xorg; [
    libX11
    libXpm
    libXt
    libXtst
  ]);

  makeFlags = [ "gamesdir=$(out)/bin" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "X-windows application that will let it snow on the root, in between and on windows";
    mainProgram = "xsnow";
    homepage = "https://ratrabbit.nl/ratrabbit/xsnow/";
    changelog = "https://ratrabbit.nl/ratrabbit/xsnow/changelog/index.html";
    downloadPage = "https://ratrabbit.nl/ratrabbit/xsnow/downloads/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      robberer
      griffi-gh
    ];
    platforms = platforms.unix;
  };
}
