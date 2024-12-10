{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  SDL,
  autoreconfHook,
  pango,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "SDL_Pango";
  version = "0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/sdlpango/${pname}-${version}.tar.gz";
    sha256 = "197baw1dsg0p4pljs5k0fshbyki00r4l49m1drlpqw6ggawx6xbz";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/s/sdlpango/0.1.2-6/debian/patches/api_additions.patch";
      sha256 = "00p5ry5gd3ixm257p9i2c4jg0qj8ipk8nf56l7c9fma8id3zxyld";
    })
    ./fixes.patch
  ];

  preConfigure = "autoreconf -i -f";
  configureFlags = lib.optional stdenv.isDarwin "--disable-sdltest";

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    SDL
    pango
  ];

  meta = with lib; {
    description = "Connects the Pango rendering engine to SDL";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    homepage = "https://sdlpango.sourceforge.net/";
    maintainers = with maintainers; [ puckipedia ];
  };
}
