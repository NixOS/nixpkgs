{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, libxklavier
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "libmatekbd";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1b8iv2hmy8z2zzdsx8j5g583ddxh178bq8dnlqng9ifbn35fh3i2";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    gtk3
    libxklavier
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Keyboard management library for MATE";
    homepage = "https://github.com/mate-desktop/libmatekbd";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
