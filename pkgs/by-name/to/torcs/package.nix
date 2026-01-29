{
  fetchpatch,
  fetchurl,
  lib,
  stdenv,
  libGLU,
  libglut,
  libX11,
  plib,
  openal,
  freealut,
  libXrandr,
  xorgproto,
  libXext,
  libSM,
  libICE,
  libXi,
  libXt,
  libXrender,
  libXxf86vm,
  libvorbis,
  libpng,
  zlib,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "torcs";
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

  postInstall = ''
    install -D -m644 Ticon.png $out/share/pixmaps/torcs.png
    install -D -m644 torcs.desktop $out/share/applications/torcs.desktop
  '';

  postPatch = ''
    sed -i -e s,/bin/bash,`type -P bash`, src/linux/torcs.in
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    libGLU
    libglut
    libX11
    plib
    openal
    freealut
    libXrandr
    xorgproto
    libXext
    libSM
    libICE
    libXi
    libXt
    libXrender
    libXxf86vm
    libpng
    zlib
    libvorbis
  ];

  installTargets = "install datainstall";

  meta = {
    description = "Car racing game";
    homepage = "https://torcs.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pixel-87 ];
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
  };
})
