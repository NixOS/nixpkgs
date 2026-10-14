{
  fetchpatch,
  fetchurl,
  lib,
  stdenv,
  libGLU,
  libglut,
  libx11,
  plib,
  openal,
  freealut,
  libxrandr,
  xorgproto,
  libxext,
  libsm,
  libice,
  libxi,
  libxt,
  libxrender,
  libxxf86vm,
  libvorbis,
  libpng,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "torcs-without-data";
  version = "1.3.10";

  src = fetchurl {
    url = "mirror://sourceforge/torcs/all-in-one/${finalAttrs.version}/torcs-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-odQQNf5ip+jbAZHxNhXnymiUVEn4v2ohYdF6/y/+iis=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/torcs/raw/fb0711c171b38c4648dc7c048249ec20f79eb8e2/debian/patches/format-argument.patch";
      sha256 = "sha256-9tVBdVxk6YU4CXK633jYakq8BkDFx40bEjOBOhN/46g=";
      postFetch = ''
        sed -i 's/\r$//' "$out"
      '';
    })
  ];

  postPatch = ''
    sed -i -e s,/bin/bash,`type -P bash`, src/linux/torcs.in
  '';

  buildInputs = [
    libGLU
    libglut
    libx11
    plib
    openal
    freealut
    libxrandr
    xorgproto
    libxext
    libsm
    libice
    libxi
    libxt
    libxrender
    libxxf86vm
    libpng
    zlib
    libvorbis
  ];

  meta = {
    description = "Car racing game (does not come with the game data required to run)";
    homepage = "https://torcs.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pixel-87 ];
    platforms = lib.platforms.linux;
  };
})
