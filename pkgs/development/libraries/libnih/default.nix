{ stdenv, fetchurl, pkgconfig, dbus, expat }:

let version = "1.0.1"; in

stdenv.mkDerivation rec {
  name = "libnih-${version}";
  
  src = fetchurl {
    url = "http://code.launchpad.net/libnih/1.0/${version}/+download/libnih-${version}.tar.gz";
    sha256 = "1sjkhpryk9vrv84bbab7b47spq60rkycm10ygnjfybjypk6hs7ds";
  };

  buildInputs = [ pkgconfig dbus expat ];
  
  meta = {
    description = "A small library for C application development";
    homepage = https://launchpad.net/libnih;
    license = "GPLv2";
  };
}
