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

  meta = with lib; {
    description = "Media tools for MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ chpatrick ];
    teams = [ teams.mate ];
  };
}
