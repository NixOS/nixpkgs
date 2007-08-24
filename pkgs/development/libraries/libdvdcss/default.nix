{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdvdcss-1.2.9";
  src = fetchurl {
    url = http://download.videolan.org/pub/libdvdcss/1.2.9/libdvdcss-1.2.9.tar.bz2;
    md5 = "553383d898826c285afb2ee453b07868";
  };
}
