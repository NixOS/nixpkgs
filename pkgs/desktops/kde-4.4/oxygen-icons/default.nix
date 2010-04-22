{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/oxygen-icons-4.4.2.tar.bz2;
    sha256 = "0n0pyf861a5y1j03d9qyb8w7xnn81w2i503pv3lh48bvk1pc0zim";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
