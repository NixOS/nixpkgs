{ stdenv, fetchurl, libpng, libjpeg, giflib, libtiff }:

stdenv.mkDerivation rec {
  name = "libwebp-0.4.0";

  src = fetchurl {
    url = "http://webp.googlecode.com/files/${name}.tar.gz";
    sha256 = "0sadjkx8m6sf064r5gngjvz4b5246q3j27dlaml5b1k3x5vkb49i";
  };

  buildInputs = [ libpng libjpeg giflib libtiff ];

  configureFlags = [
    "--enable-libwebpmux"
    "--enable-libwebpdemux"
    "--enable-libwebpdecoder"
  ];

  meta = {
    homepage = http://code.google.com/p/webp/;
    description = "Tools and library for the WebP image format";

    /* It has its own licence, google-related, but that looks like BSD */
    license = "free";
  };
}
