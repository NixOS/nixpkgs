{stdenv, fetchurl, libpng, libjpeg}:

stdenv.mkDerivation rec {
  name = "libwebp-0.1.3";
  
  src = fetchurl {
    url = "http://webp.googlecode.com/files/${name}.tar.gz";
    sha256 = "1fkssvg99s9ypswh4ywkirgcy1wmy3b6388f3cqj4a4vwdb89ca0";
  };

  buildInputs = [ libpng libjpeg ];

  meta = {
    homepage = http://code.google.com/p/webp/;
    description = "Tools and library for the WebP image format";

    /* It has its own licence, google-related, but that looks like BSD */
    license = "free";
  };
}
