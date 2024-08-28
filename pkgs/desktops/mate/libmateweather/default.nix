{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, glib
, glib-networking
, libxml2
, gtk3
, libsoup
, tzdata
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "libmateweather";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "VUNz3rWzk7nYSydd0spmyaSi0ObskgRPq4qlPjAy0rU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gettext
    glib # glib-compile-schemas
    libxml2 # xmllint
  ];

  buildInputs = [
    libsoup
    tzdata
  ];

  propagatedBuildInputs = [
    glib
    glib-networking # for obtaining IWIN forecast data
    gtk3
  ];

  configureFlags = [
    "--with-zoneinfo-dir=${tzdata}/share/zoneinfo"
    "--enable-locations-compression"
  ];

  preFixup = "rm -f $out/share/icons/mate/icon-theme.cache";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Library to access weather information from online services for MATE";
    homepage = "https://github.com/mate-desktop/libmateweather";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
