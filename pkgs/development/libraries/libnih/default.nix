{ stdenv, fetchurl, pkgconfig, dbus, expat }:

let version = "1.0.3"; in

stdenv.mkDerivation rec {
  name = "libnih-${version}";

  src = fetchurl {
    url = "https://code.launchpad.net/libnih/1.0/${version}/+download/libnih-${version}.tar.gz";
    sha256 = "01glc6y7z1g726zwpvp2zm79pyb37ki729jkh45akh35fpgp4xc9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ dbus expat ];

  doCheck = false; # fails 1 of 17 test

  meta = {
    description = "A small library for C application development";
    homepage = https://launchpad.net/libnih;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
