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
  version = "1.3.8";

  src = fetchurl {
    url = "mirror://sourceforge/torcs/torcs-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-S5Z3NUX7NkEZgqbziXIF64/VciedTOVp8s4HsI6Jp68=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/torcs/raw/fb0711c171b38c4648dc7c048249ec20f79eb8e2/debian/patches/format-argument.patch";
      sha256 = "04advcx88yh23ww767iysydzhp370x7cqp2wf9hk2y1qvw7mxsja";
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
