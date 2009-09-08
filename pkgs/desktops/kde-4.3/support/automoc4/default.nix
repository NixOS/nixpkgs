{stdenv, fetchurl, lib, cmake, qt4}:

stdenv.mkDerivation {
  name = "automoc4-0.9.88";
  src = fetchurl {
    url = mirror://kde/stable/automoc4/0.9.88/automoc4-0.9.88.tar.bz2;
    md5 = "91bf517cb940109180ecd07bc90c69ec";
  };
  buildInputs = [ cmake qt4 ];
  meta = {
    description = "KDE Meta Object Compiler";
    license = "BSD";
    maintainers = [ lib.maintainers.sander ];
  };
}
