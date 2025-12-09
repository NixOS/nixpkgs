{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gtk3,
  libgee,
  gettext,
  vala,
  gnome,
  libintl,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "libgnome-games-support";
  version = "1.8.2";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome-games-support/${lib.versions.majorMinor version}/libgnome-games-support-${version}.tar.xz";
    sha256 = "KENGBKewOHMawCMXMTiP8QT1ZbsjMMwk54zaBM/T730=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    libintl
  ];

  propagatedBuildInputs = [
    # Required by libgnome-games-support-1.pc
    glib
    gtk3
    libgee
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libgnome-games-support";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = "https://gitlab.gnome.org/GNOME/libgnome-games-support";
    license = licenses.lgpl3;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
}
