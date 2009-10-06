{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.3.2";
  src = fetchurl {
    url = mirror://kde/stable/4.3.2/src/oxygen-icons-4.3.2.tar.bz2;
    sha1 = "gij2a7hyhb7bcj009hl3nnlfmjcwfmw2";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
