{
  lib,
  stdenv,
  fetchurl,
<<<<<<< HEAD
  cmake,
  pkg-config,
  qt6,
=======
  pkg-config,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libjack2,
  alsa-lib,
  liblo,
  lv2,
<<<<<<< HEAD
=======
  libsForQt5,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "synthv1";
<<<<<<< HEAD
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
=======
  version = "0.9.23";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/synthv1-${finalAttrs.version}.tar.gz";
    hash = "sha256-0V72T51icT/t9fJf4mwcMYZLjzTPnmiCbU+BdwnCmw4=";
  };

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    libjack2
    alsa-lib
    liblo
    lv2
  ];

  nativeBuildInputs = [
<<<<<<< HEAD
    cmake
    pkg-config
    qt6.wrapQtAppsHook
=======
    pkg-config
    libsForQt5.wrapQtAppsHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
