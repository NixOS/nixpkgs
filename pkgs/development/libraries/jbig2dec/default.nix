{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "jbig2dec-0.13";

  src = fetchurl {
    url = "http://downloads.ghostscript.com/public/jbig2dec/${name}.tar.gz";
    sha256 = "04akiwab8iy5iy34razcvh9mcja9wy737civ3sbjxk4j143s1b2s";
  };

  patches =
    [ (fetchpatch {
        url = "http://git.ghostscript.com/?p=jbig2dec.git;a=patch;h=e698d5c11d27212aa1098bc5b1673a3378563092";
        sha256 = "1fc8xm1z98xj2zkcl0zj7dpjjsbz3vn61b59jnkhcyzy3iiczv7f";
        name = "CVE-2016-9601.patch";
      })
    ];

  meta = {
    homepage = https://www.ghostscript.com/jbig2dec.html;
    description = "Decoder implementation of the JBIG2 image compression format";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
