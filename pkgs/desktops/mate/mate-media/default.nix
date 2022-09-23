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
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fiwzsir8i1bqz7g7b20g5zs28qq63j41v9c5z69q8fq7wh1nwwb";
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

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Media tools for MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members ++ (with maintainers; [ chpatrick ]);
  };
}
