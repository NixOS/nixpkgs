{ stdenv, fetchurl, fetchpatch, autoconf, automake, libtool, autoreconfHook, pkgconfig, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-${version}";
  version = "0.34.0";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/${name}.tar.bz2";
    sha256 = "184lazwdpv67zrlxxswpxrdap85wminh1gmq1i5lcz6iycw39fir";
  };

  patches = stdenv.lib.optionals stdenv.cc.isClang [
    (fetchpatch {
      name = "builtin-shuffle.patch";
      url = https://patchwork.freedesktop.org/patch/177506/raw;
      sha256 = "0rvraq93769dy2im2m022rz99fcdxprgc2fbmasnddcwrqy1x3xr";
    })
  ];

  nativeBuildInputs = [ pkgconfig ]
    ++ stdenv.lib.optionals stdenv.cc.isClang [ autoconf automake libtool autoreconfHook ];

  buildInputs = [ libpng ];

  configureFlags = stdenv.lib.optional stdenv.isAarch32 "--disable-arm-iwmmxt";

  doCheck = true;

  postInstall = glib.flattenInclude;

  meta = with stdenv.lib; {
    homepage = http://pixman.org;
    description = "A low-level library for pixel manipulation";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
