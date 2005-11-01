{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdrm-1.0.5";
  src = fetchurl {
    url = http://dri.freedesktop.org/libdrm/libdrm-1.0.5.tar.gz;
    md5 = "e31257237969d5fc2c9e9eb4ad8110cf";
  };
}
