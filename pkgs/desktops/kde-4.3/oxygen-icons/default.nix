{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/oxygen-icons-4.3.5.tar.bz2;
    sha256 = "18k75sinlgha5169myv1fvglv9gc823lxphr1yyzpmgqpk173qpq";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
