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

stdenv.mkDerivation(finalAttrs: {
  pname = "teg";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "wfx";
    repo = "teg";
    tag = finalAttrs.version;
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

    cp teg* $out/bin

    cp client/gui-gnome/teg.desktop $out/share/applications

    cp -r client/themes/* $out/share/teg/themes
    ls client/themes

    glib-compile-schemas --targetdir=compiled-schema client/gui-gnome
    cp compiled-schema/gschemas.compiled $out/share/glib-2.0/schemas

    runHook postInstall
  '';

  meta = {
    description = "Clone of the board game Plan Tactico y Estrategico de la Guerra";
    longDescription = "Tenes Empanadas Graciela (TEG) is a clone of 'Plan Tactico y Estrategico de la Guerra', which is a pseudo-clone of Risk, a multiplayer turn-based strategy game.";
    license = lib.licenses.gpl2Only;
    mainProgram = "tegclient";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ reylak ];
  };
})
