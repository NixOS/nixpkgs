{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libjack2,
  alsa-lib,
  liblo,
  lv2,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "synthv1";
  version = "0.9.23";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/synthv1-${finalAttrs.version}.tar.gz";
    hash = "sha256-0V72T51icT/t9fJf4mwcMYZLjzTPnmiCbU+BdwnCmw4=";
  };

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    libjack2
    alsa-lib
    liblo
    lv2
  ];

  nativeBuildInputs = [
    pkg-config
    libsForQt5.wrapQtAppsHook
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
