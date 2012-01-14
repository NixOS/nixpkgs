{stdenv, fetchurl, pkgconfig, libpthreadstubs}:

stdenv.mkDerivation (rec {
  name = "libdrm-2.4.24";
  
  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "19dnzy7g6jqfjz38dp187b97vb4a8h4k748x56gsyn24ys0j60f7";
  };

  buildInputs = [ pkgconfig libpthreadstubs ];

  patches = [ ./libdrm-apple.patch ];

  preConfigure = ''
    # General case: non intel.
    if test -n "$crossConfig"; then
      configureFlags="$configureFlags --disable-intel";
    fi
  '' + stdenv.lib.optionalString stdenv.isDarwin
  "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";

  meta = {
    homepage = http://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
  };
} // (stdenv.lib.optionalAttrs stdenv.isDarwin { configureFlags = [ "-C" ]; }))
