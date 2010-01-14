{stdenv, fetchurl, pkgconfig, libpthreadstubs}:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.17";
  
  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "0sii8bhplb99i4x67626sd4pm1c2i3i0c73rdma71sdh233fg95q";
  };

  buildInputs = [ pkgconfig libpthreadstubs ];

  preConfigure = ''
    # General case: non intel.
    if test -n "$crossConfig"; then
      configureFlags="$configureFlags --disable-intel";
    fi
  '';

  meta = {
    homepage = http://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
  };
}
