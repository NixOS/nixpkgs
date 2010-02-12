{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/oxygen-icons-4.4.0.tar.bz2;
    sha256 = "1y50hvr2chb8ng673skynra4m7ka644phwwyg8609ac03jbbg80j";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
