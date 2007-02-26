{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdrm-2.3.0";
  src = fetchurl {
    url = http://dri.freedesktop.org/libdrm/libdrm-2.3.0.tar.bz2;
    sha256 = "13l4ysid1raasmq18x1kjp5xmwqg6pv9431n25c88l7agx113izq";
  };
}
