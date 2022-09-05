{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, libsoup
, tzdata
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "libmateweather";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "05bvc220p135l6qnhh3qskljxffds0f7fjbjnrpq524w149rgzd7";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    gtk3
    libsoup
    tzdata
  ];

  configureFlags = [
    "--with-zoneinfo-dir=${tzdata}/share/zoneinfo"
    "--enable-locations-compression"
  ];

  preFixup = "rm -f $out/share/icons/mate/icon-theme.cache";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Library to access weather information from online services for MATE";
    homepage = "https://github.com/mate-desktop/libmateweather";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
