{
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  glib,
  gnumake,
  goocanvas_2,
  libtool,
  libxml2,
  pkg-config,
  wrapGAppsHook3,
  xmlto,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "tenesEmpanadasGraciela";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "wfx";
    repo = "teg";
    tag = version;
    hash = "sha256-NbuQOaMFFVFOTvEOHoXuzKccnmyIEKeYdB2bXzpf7VQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    glib
    gnumake
    goocanvas_2
    libtool
    libxml2
    pkg-config
    wrapGAppsHook3
    xmlto
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/teg/themes $out/share/glib-2.0/schemas compiled-schema

    cp tegclient $out/bin
    cp tegserver $out/bin
    cp tegrobot $out/bin

    cp client/gui-gnome/teg.desktop $out/share/applications

    cp -r client/themes/m2 $out/share/teg/themes
    cp -r client/themes/m3 $out/share/teg/themes
    cp -r client/themes/teg_game $out/share/teg/themes
    cp -r client/themes/teg_classic $out/share/teg/themes
    cp -r client/themes/risk_game $out/share/teg/themes
    cp -r client/themes/modern $out/share/teg/themes
    cp -r client/themes/draco $out/share/teg/themes
    cp -r client/themes/sentimental $out/share/teg/themes
    ls client/themes

    glib-compile-schemas --targetdir=compiled-schema client/gui-gnome
    cp compiled-schema/gschemas.compiled $out/share/glib-2.0/schemas

    runHook postInstall
  '';

  meta = with lib; {
    description = "Clone of the board game Plan Tactico y Estrategico de la Guerra";
    longDescription = "Tenes Empanadas Graciela (TEG) is a clone of 'Plan Tactico y Estrategico de la Guerra', which is a pseudo-clone of Risk, a multiplayer turn-based strategy game.";
    license = licenses.gpl2Only;
    mainProgram = "tegclient";
    platforms = platforms.all;
    maintainers = with maintainers; [ reylak ];
  };
}
