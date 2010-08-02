{stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  name = "oxygen-icons-4.4.92";
  src = fetchurl {
    url = "mirror://kde/unstable/4.4.92/src/${name}.tar.bz2";
    sha256 = "1aqc5p93c9jz660x94pxx7anamrpmwd490jy0lw38y99lbdhgz9k";
  };
  buildInputs = [ cmake ];
  meta = with stdenv.lib; {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ maintainers.sander ];
  };
}
