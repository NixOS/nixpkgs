{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "spice-protocol-0.10.1";

  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "0drmy2ws7qwmvjxfynhssbvh1y954rfik99hnl789g7yg6vcpxp5";
  };

  meta = {
    description = "Protocol headers for the SPICE protocol.";
    homepage = http://www.spice-space.org;
    license = stdenv.lib.licenses.bsd3;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
