{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/oxygen-icons-4.4.5.tar.bz2;
    sha256 = "15nfh8zl54a7b3pyqjiabv82srkp7c8gl9fpsy9ydw742lvs0pr7";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.all;
  };
}
