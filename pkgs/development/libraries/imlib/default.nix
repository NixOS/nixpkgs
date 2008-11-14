{stdenv, fetchurl, libX11, libXext, xextproto, libjpeg, libungif, libtiff, libpng}:

stdenv.mkDerivation {
  name = "imlib-1.9.15";
  src = fetchurl {
    url = http://nixos.org/tarballs/imlib-1.9.15.tar.gz;
    md5 = "2a5561457e7f8b2e04d88f73508fd13a";
  };

  configureFlags = "
    --disable-shm
    --x-includes=${libX11}/include
    --x-libraries=${libX11}/lib";

  buildInputs = [libjpeg libXext libX11 xextproto libtiff libungif libpng];
}
