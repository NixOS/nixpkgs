{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig
, giflib, libjpeg, libpng, libtiff, libwebp, openjpeg, zlib
}:

stdenv.mkDerivation rec {
  name = "leptonica-${version}";
  version = "1.74.1";

  src = fetchurl {
    url = "http://www.leptonica.org/source/${name}.tar.gz";
    sha256 = "0qpcidvv6igybrrhj0m6j47g642c8sk1qn4dpj82mgd38xx52skl";
  };

  patches = stdenv.lib.singleton (fetchpatch {
    # configure: Support pkg-config
    url = "https://github.com/DanBloomberg/leptonica/commit/"
        + "4476d162cc191a0fefb2ce434153e12bbf188664.patch";
    sha256 = "1razzp2g49shfaravfqpxm3ivcd1r92lvqysll6nnf6d1wp9865s";
  });

  postPatch = ''
    # Remove the AC_SUBST() macros on *_LIBS, because the *_LIBS variables will
    # be automatically set by PKG_CHECK_MODULES() since autotools 0.24 and
    # using the ones that are set here in Leptonica's configure.ac do not
    # include -L linker flags.
    sed -i -e '/PKG_CHECK_MODULES/,/^ *\])/s/AC_SUBST([^)]*)//' configure.ac

    # The giflib package doesn't ship a pkg-config file, so we need to inject
    # the linker search path.
    substituteInPlace configure.ac --replace -lgif \
      ${stdenv.lib.escapeShellArg "'-L${giflib}/lib -lgif'"}
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ giflib libjpeg libpng libtiff libwebp openjpeg zlib ];

  meta = {
    description = "Image processing and analysis library";
    homepage = http://www.leptonica.org/;
    # Its own license: http://www.leptonica.org/about-the-license.html
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
  };
}
