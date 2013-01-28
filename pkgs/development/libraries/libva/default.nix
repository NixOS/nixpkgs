{ stdenv, fetchurl, autoconf, automake, libtool, libX11, pkgconfig, libXext, mesa
, libdrm, libXfixes, intelgen4asm, which }:

stdenv.mkDerivation rec {
  name = "libva-1.1.0";
  
  src = fetchurl {
    url = "http://cgit.freedesktop.org/libva/snapshot/${name}.tar.bz2";
    sha256 = "0lqkharln67p60jlyz9y662gjgqk2iy2nrj84j1jr1nzgw7j01a5";
  };

  buildInputs = [ autoconf automake libtool libX11 libXext pkgconfig mesa libdrm
    libXfixes intelgen4asm which ];

  configureFlags = [ "--enable-glx" ];

  preConfigure = "sh autogen.sh";

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = "MIT";
    description = "VAAPI library: Video Acceleration API";
  };
}
