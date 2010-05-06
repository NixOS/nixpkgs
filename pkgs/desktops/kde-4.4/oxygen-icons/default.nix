{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/oxygen-icons-4.4.3.tar.bz2;
    sha256 = "1pqz6l8zdijcz4r2qrkx92skcqbijiip90m2j3aiawr1m6rv2l0j";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
