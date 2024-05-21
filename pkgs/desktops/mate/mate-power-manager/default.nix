{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, glib
, itstool
, libxml2
, mate-desktop
, mate-panel
, libnotify
, libcanberra-gtk3
, libsecret
, dbus-glib
, upower
, gtk3
, libtool
, polkit
, wrapGAppsHook3
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-power-manager";
  version = "1.28.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "jr3LdLYH6Ggza6moFGze+Pl7zlNcKwyzv2UMWPce7iE=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libtool
    wrapGAppsHook3
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
    mate-desktop
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
