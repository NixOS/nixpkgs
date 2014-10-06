{ stdenv, fetchurl, libpng, libjpeg, giflib, libtiff }:

stdenv.mkDerivation rec {
  name = "libwebp-0.4.1";

  src = fetchurl {
    url = "http://downloads.webmproject.org/releases/webp/${name}.tar.gz";
    sha256 = "09yhfhb90hlhr0vq8ajnpk9rxvmb1bkiywcqm7xahl35yvk4ddh0";
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
