{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  libtool,
  gtk-layer-shell,
  gtk3,
  libcanberra-gtk3,
  libmatemixer,
  libxml2,
  mate-desktop,
  mate-panel,
  wayland,
  wrapGAppsHook3,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-media";
  version = "1.28.1";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "vNwQLiL2P1XmMWbVxwjpHBE1cOajCodDRaiGCeg6mRI=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libtool
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk-layer-shell
    gtk3
    libcanberra-gtk3
    libmatemixer
    libxml2
    mate-desktop
    mate-panel
    wayland
  ];

  configureFlags = [ "--enable-in-process" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = {
    description = "Media tools for MATE";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ chpatrick ];
    teams = [ lib.teams.mate ];
  };
}
