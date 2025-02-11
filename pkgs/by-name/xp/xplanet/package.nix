{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  freetype,
  pango,
  libpng,
  libtiff,
  giflib,
  libjpeg,
  netpbm,
}:

stdenv.mkDerivation rec {
  pname = "xplanet";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/xplanet/${pname}-${version}.tar.gz";
    sha256 = "1rzc1alph03j67lrr66499zl0wqndiipmj99nqgvh9xzm1qdb023";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    freetype
    pango
    libpng
    libtiff
    giflib
    libjpeg
    netpbm
  ];

  patches = [
    (fetchpatch {
      name = "giflib6.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/ce6f25eb369dc011161613894f01fd0a6ae85a09/trunk/giflib6.patch";
      sha256 = "173l0xkqq0v2bpaff7hhwc7y2aw5cclqw8988k1nalhyfbrjb8bl";
    })
    (fetchpatch {
      name = "xplanet-c++11.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/ce6f25eb369dc011161613894f01fd0a6ae85a09/trunk/xplanet-c++11.patch";
      sha256 = "0vldai78ixw49bxch774pps6pq4sp0p33qvkvxywcz7p8kzpg8q2";
    })
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  meta = with lib; {
    description = "Renders an image of the earth or other planets into the X root window";
    mainProgram = "xplanet";
    homepage = "https://xplanet.sourceforge.net";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      lassulus
      sander
    ];
    platforms = platforms.all;
  };
}
