{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.9";
  
  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "18i1c4pcy2db2alali1yxg1s72vdpikivahmbrp7wf204kn236zd";
  };

  meta = {
    homepage = http://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
  };
}
