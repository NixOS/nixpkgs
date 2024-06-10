{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3-x11
, libxklavier
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "libmatekbd";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "XS5YSDwrI9M1A9JMiPi5CijMAYnX5AAbPic6YE9v6A4=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    gtk3-x11
    libxklavier
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Keyboard management library for MATE";
    homepage = "https://github.com/mate-desktop/libmatekbd";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
