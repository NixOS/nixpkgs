{stdenv, fetchurl, pkgconfig, libpthreadstubs}:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.15";
  
  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "1pm7iddv3yjwvqmlbdmj9m55bmkfcfzq0wvqpgx4gkmdjfd8kzxw";
  };

  buildInputs = [ pkgconfig libpthreadstubs ];

  meta = {
    homepage = http://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
  };
}
