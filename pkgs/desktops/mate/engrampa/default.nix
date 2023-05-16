{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, libxml2
, gtk3
<<<<<<< HEAD
=======
, file
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
<<<<<<< HEAD
# can be defaulted to true once engrampa builds with meson (version > 1.27.0)
, withMagic ? stdenv.buildPlatform.canExecute stdenv.hostPlatform, file
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "engrampa";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "8CJBB6ek6epjCcnniqX6rIAsTPcqSawoOqnnrh6KbEo=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
<<<<<<< HEAD
    libxml2  # for xmllint
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapGAppsHook
  ];

  buildInputs = [
<<<<<<< HEAD
    gtk3
    mate.caja
    hicolor-icon-theme
    mate.mate-desktop
  ] ++ lib.optionals withMagic [
    file
=======
    libxml2
    gtk3
    file #libmagic
    mate.caja
    hicolor-icon-theme
    mate.mate-desktop
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  configureFlags = [
    "--with-cajadir=$$out/lib/caja/extensions-2.0"
<<<<<<< HEAD
  ] ++ lib.optionals withMagic [
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--enable-magic"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Archive Manager for MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
