{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, gobject-introspection
, libappindicator-gtk3
, libindicator-gtk3
, polkit
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-polkit";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "9bewtd/FMwLEBAMkWZjrkSGvP1DnFmagmrc7slRSA1c=";
  };

  nativeBuildInputs = [
    gobject-introspection
    gettext
    pkg-config
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
    libindicator-gtk3
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
