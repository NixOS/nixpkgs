{stdenv, fetchurl, pkgconfig, libpthreadstubs}:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.23";
  
  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "060wj5mb0y76v5nfdkk8sd6gszi8ihd4ix9pv4d7mfpdqdl6vw60";
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
