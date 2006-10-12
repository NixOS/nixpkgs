{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdvdcss-1.2.9";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libdvdcss-1.2.9.tar.bz2;
    md5 = "553383d898826c285afb2ee453b07868";
  };
}
