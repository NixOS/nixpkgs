{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig
, giflib, libjpeg, libpng, libtiff, libwebp, openjpeg, zlib, which, gnuplot
}:

stdenv.mkDerivation rec {
  name = "leptonica-${version}";
  version = "1.74.1";

  src = fetchurl {
    url = "http://www.leptonica.org/source/${name}.tar.gz";
    sha256 = "0qpcidvv6igybrrhj0m6j47g642c8sk1qn4dpj82mgd38xx52skl";
  };

  patches = [
    (fetchpatch {
      # configure: Support pkg-config
      url = "https://github.com/DanBloomberg/leptonica/commit/"
          + "4476d162cc191a0fefb2ce434153e12bbf188664.patch";
      sha256 = "1razzp2g49shfaravfqpxm3ivcd1r92lvqysll6nnf6d1wp9865s";
    })
    # stripped down copy of upstream commit b88c821f8d347bce0aea86d606c710303919f3d2
    ./CVE-2018-3836.patch
    (fetchpatch {
      # CVE-2018-7186
      url = "https://github.com/DanBloomberg/leptonica/commit/"
          + "ee301cb2029db8a6289c5295daa42bba7715e99a.patch";
      sha256 = "0cgb7mvz2px1rg5i80wk1wxxjvzjga617d8q6j7qygkp7jm6495d";
    })
    (fetchpatch {
      # CVE-2018-7247
      url = "https://github.com/DanBloomberg/leptonica/commit/"
          + "c1079bb8e77cdd426759e466729917ca37a3ed9f.patch";
      sha256 = "1z4iac5gwqggh7aa8cvyp6nl9fwd1v7wif26caxc9y5qr3jj34qf";
    })
    (fetchpatch {
      # CVE-2018-7440
      url = "https://github.com/DanBloomberg/leptonica/commit/"
          + "49ecb6c2dfd6ed5078c62f4a8eeff03e3beced3b.patch";
      sha256 = "1hjmva98iaw9xj7prg7aimykyayikcwnk4hk0380007hqb35lqmy";
    })
  ];

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

  checkInputs = [ which gnuplot ];
  doCheck = true;

  meta = {
    description = "Image processing and analysis library";
    homepage = http://www.leptonica.org/;
    # Its own license: http://www.leptonica.org/about-the-license.html
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
  };
}
