{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, libtool
, libxml2
, libcanberra-gtk3
, gtk3
, mate
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-media";
  version = "1.26.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "r0ZjlXTMOIUTCJyhC7FB/8Pm0awz5zDkII21dZZChQ8=";
  };

  buildInputs = [
    libxml2
    libcanberra-gtk3
    gtk3
    mate.libmatemixer
    mate.mate-panel
    mate.mate-desktop
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    libtool
    wrapGAppsHook
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Media tools for MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members ++ (with maintainers; [ chpatrick ]);
  };
}
