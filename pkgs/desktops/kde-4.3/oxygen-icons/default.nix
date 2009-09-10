{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/oxygen-icons-4.3.1.tar.bz2;
    sha1 = "75a82d2e80d946333f63e32db56767c3ed17ba33";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
