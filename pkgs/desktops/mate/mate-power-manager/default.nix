{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, glib
, itstool
, libxml2
, mate-panel
, libnotify
, libcanberra-gtk3
, libsecret
, dbus-glib
, upower
, gtk3
, libtool
, polkit
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-power-manager";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "IM2dIu0Eur+Yu1DnGg7F14qKR2KHcjJ4+H2nbKv7EEI=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libtool
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    itstool
    libxml2
    libcanberra-gtk3
    gtk3
    libsecret
    libnotify
    dbus-glib
    upower
    polkit
    mate-panel
  ];

  configureFlags = [ "--enable-applets" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "The MATE Power Manager";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members ++ (with maintainers; [ chpatrick ]);
  };
}
