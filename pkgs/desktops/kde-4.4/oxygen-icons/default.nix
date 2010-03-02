{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.4.1";
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/oxygen-icons-4.4.1.tar.bz2;
    sha256 = "04s386g978fq5imbgiqp3qmjm1391mvnxg973i7ik4pxbc75irpr";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
