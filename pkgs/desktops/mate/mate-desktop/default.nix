{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, isocodes
, gnome
, gtk3
, dconf
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-desktop";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "18sj8smf0b998m5qvki37hxg0agcx7wmgz9z7cwv6v48i2dnnz2z";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    dconf
    gtk3
    isocodes
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Library with common API for various MATE modules";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}
