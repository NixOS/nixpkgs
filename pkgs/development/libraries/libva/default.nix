{ stdenv, fetchurl, autoconf, automake, libtool, libX11, pkgconfig, libXext, mesa, libdrm, libXfixes, intelgen4asm }:

stdenv.mkDerivation rec {
  name = "libva-1.0.12";
  
  src = fetchurl {
    url = "http://cgit.freedesktop.org/libva/snapshot/${name}.tar.bz2";
    sha256 = "1xg8zvmh75w63sc8ykagzrbzswph6g9jardy8v83glkqzilaw2p8";
  };

  buildInputs = [ autoconf automake libtool libX11 libXext pkgconfig mesa libdrm
    libXfixes intelgen4asm ];

  configureFlags = [ "--enable-i965-driver" "--enable-glx" ];

  preConfigure = "sh autogen.sh";

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = "MIT";
    description = "VAAPI library: Video Acceleration API";
  };
}
