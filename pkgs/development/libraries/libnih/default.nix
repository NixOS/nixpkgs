{ stdenv, fetchurl, pkgconfig, dbus, expat }:

let version = "1.0.2"; in

stdenv.mkDerivation rec {
  name = "libnih-${version}";
  
  src = fetchurl {
    url = "http://code.launchpad.net/libnih/1.0/${version}/+download/libnih-${version}.tar.gz";
    sha256 = "0zi5qacppsipc03gqdr0vpgfqk17kxxxnrqzb6md12kixfahl33v";
  };

  buildInputs = [ pkgconfig dbus expat ];
  
  meta = {
    description = "A small library for C application development";
    homepage = https://launchpad.net/libnih;
    license = "GPLv2";
  };
}
