{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/oxygen-icons-4.3.3.tar.bz2;
    sha1 = "b93d8q30ymrpgsj6f5n4ryip5cnf15x8";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
