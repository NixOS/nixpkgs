{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  gtk3,
  gobject-introspection,
  libayatana-appindicator,
  polkit,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-polkit";
  version = "1.28.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "NQod0KjtaiycGDz/KiHzlCmelo/MauLoyTxWXa5gSug=";
  };

  nativeBuildInputs = [
    gobject-introspection
    gettext
    pkg-config
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
    polkit
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Integrates polkit authentication for MATE desktop";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
