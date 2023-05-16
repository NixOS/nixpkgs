{ lib
, stdenv
, fetchurl
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, gettext
, itstool
, glib
, gtk3
, libxml2
, libgtop
, libcanberra-gtk3
, inkscape
, udisks2
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-utils";
<<<<<<< HEAD
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "L1NHWxoJkd1ak9ndpY/KTkFvJZJTWG2UpbEQjxI3BiA=";
  };

  patches = [
    # Hopefully helps "libxml2.treeError: xmlSetProp() failed"
    # This patch is not part of upstream yet.
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=919058
    # https://github.com/mate-desktop/mate-utils/issues/210
    (fetchpatch {
      url = "https://salsa.debian.org/debian-mate-team/mate-utils/-/raw/2b43d78f3fdbf0aa50716b62bcada2ef015957c6/debian/patches/1001_fix-gsearchtool-pt-help-translation.patch";
      sha256 = "SZVpdup/bNv+3hEGQ0L13mgXyNm+wRcL53t9/Oi24wA=";
    })
  ];

=======
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0bkqj8qwwml9xyvb680yy06lv3dzwkv89yrzz5jamvz88ar6m9bw";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    inkscape
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libgtop
    libcanberra-gtk3
    libxml2
    udisks2
    mate.mate-panel
    hicolor-icon-theme
  ];

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
