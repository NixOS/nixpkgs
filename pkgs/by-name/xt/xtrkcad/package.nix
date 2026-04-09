{
  lib,
  stdenv,
  fetchhg,
  mercurial,
  cmake,
  libgcc,
  pkg-config,
  gtk2,
  libzip,
  libnxml,
  inkscape,
  doxygen,
  pandoc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xtrkcad";
  version = "5.3.1";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/xtrkcad-fork/xtrkcad";
    hash = "sha256-QtR122kC+Nqo5shw3xE/8nrHTBSgdBGLt5xBKTs5+KE=";
  };

  buildInputs = [
    cmake
    mercurial
    libgcc
    pkg-config
    inkscape
    gtk2
    libzip
    libnxml
    inkscape
    doxygen
    pandoc
  ];

  meta = {
    homepage = "https://sourceforge.net/projects/xtrkcad-fork/";
    description = "Model Railway CAD program ";
    mainProgram = "xtrkcad";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ luke-elsdon ];
    platforms = lib.platforms.linux;
  };
})
