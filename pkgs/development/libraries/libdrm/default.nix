{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdrm-2.0";
  src = fetchurl {
    url = http://dri.freedesktop.org/libdrm/libdrm-2.0.tar.gz;
    md5 = "9d1aab104eb757ceeb2c1a6d38d57411";
  };
}
