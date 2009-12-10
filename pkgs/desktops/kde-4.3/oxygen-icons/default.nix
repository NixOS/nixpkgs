{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/oxygen-icons-4.3.4.tar.bz2;
    sha1 = "9905f6b5a47db85c05f7387a75b6ae0e0fdd756e";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
