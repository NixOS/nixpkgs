{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  qt6,
  libjack2,
  alsa-lib,
  liblo,
  lv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "synthv1";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/synthv1-${finalAttrs.version}.tar.gz";
    hash = "sha256-tCxgJdl5PMNvnhPZOsNhlS3LqBksmXBojfnSLZUZKMY=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail  '"''${CONFIG_PREFIX}/''${CMAKE_INSTALL_LIBDIR}"' '"''${CMAKE_INSTALL_LIBDIR}"'
  '';

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    libjack2
    alsa-lib
    liblo
    lv2
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  meta = {
    description = "Old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    mainProgram = "synthv1_jack";
    homepage = "https://synthv1.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
