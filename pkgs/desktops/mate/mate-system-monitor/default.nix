{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, gtkmm3
, libxml2
, libgtop
, libwnck
, librsvg
, polkit
, systemd
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-system-monitor";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "HrX7m2y0qK2DCyboR6m70B1WiqvTg8Yo7p8IQJuJKOc=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtkmm3
    libxml2
    libgtop
    libwnck
    librsvg
    polkit
    systemd
  ];

  configureFlags = [ "--enable-systemd" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "System monitor for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
