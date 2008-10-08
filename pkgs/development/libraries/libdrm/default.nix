{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdrm-2.3.1";
  
  src = fetchurl {
    url = http://dri.freedesktop.org/libdrm/libdrm-2.3.1.tar.bz2;
    sha256 = "133iz3fma30diwn66ni59wp6gg5kmklqj5hzds20g5vjhf1kkzfx";
  };

  meta = {
    homepage = http://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
  };
}
