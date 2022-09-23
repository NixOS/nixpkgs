{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, libwnck
, libfakekey
, libXtst
, mate
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-netbook";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "12gdy69nfysl8vmd8lv8b0lknkaagplrrz88nh6n0rmjkxnipgz3";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libwnck
    libfakekey
    libXtst
    mate.mate-panel
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "MATE utilities for netbooks";
    longDescription = ''
      MATE utilities for netbooks are an applet and a daemon to maximize
      windows and move their titles on the panel.

      Installing these utilities is recommended for netbooks and similar
      devices with low resolution displays.
    '';
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl3Only lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
