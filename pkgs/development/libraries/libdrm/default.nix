{stdenv, fetchurl, pkgconfig, libpthreadstubs}:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.24";
  
  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "19dnzy7g6jqfjz38dp187b97vb4a8h4k748x56gsyn24ys0j60f7";
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
