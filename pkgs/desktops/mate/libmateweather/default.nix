{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
<<<<<<< HEAD
, glib
, libxml2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gtk3
, libsoup
, tzdata
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "libmateweather";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "wgCZD0uOnU0OLG99MaWHY3TD0qNsa4y1kEQAQ6hg7zo=";
  };

<<<<<<< HEAD
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gettext
    glib # glib-compile-schemas
    libxml2 # xmllint
=======
  nativeBuildInputs = [
    pkg-config
    gettext
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Library to access weather information from online services for MATE";
    homepage = "https://github.com/mate-desktop/libmateweather";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
