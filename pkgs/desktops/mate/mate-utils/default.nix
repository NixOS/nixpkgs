{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, glib
, gtk-layer-shell
, gtk3
, libxml2
, libgtop
, libcanberra-gtk3
, inkscape
, udisks2
, mate-desktop
, mate-panel
, hicolor-icon-theme
, wayland
, wrapGAppsHook3
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-utils";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "WESdeg0dkA/wO3jKn36Ywh6X9H/Ca+5/8cYYNPIviNM=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    inkscape
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk-layer-shell
    gtk3
    libgtop
    libcanberra-gtk3
    libxml2
    udisks2
    mate-desktop
    mate-panel
    hicolor-icon-theme
    wayland
  ];

  postPatch = ''
    # Workaround undefined version requirements
    # https://github.com/mate-desktop/mate-utils/issues/361
    substituteInPlace configure \
      --replace-fail '>= $GTK_LAYER_SHELL_REQUIRED_VERSION' "" \
      --replace-fail '>= $GDK_WAYLAND_REQUIRED_VERSION' ""
  '';

  configureFlags = [ "--enable-wayland" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Utilities for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
