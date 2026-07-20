{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoc,
  asciidoctor,
  cmake,
  nix-update-script,
  pkg-config,
  portaudio,
  fftw,
  fftwFloat,
  gfortran,
  hamlib_4,
  libtool,
  libusb1,
  qt5,
  boost,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wsjtx";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "WSJTX";
    repo = "wsjtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PompKWVxPpF3ie811tqy8bplnULyXdenBrR/pHvtM08=";
  };

  nativeBuildInputs = [
    asciidoc
    asciidoctor
    cmake
    gfortran
    hamlib_4 # rigctl
    libtool
    pkg-config
    qt5.qttools
    texinfo
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    fftw
    fftwFloat
    hamlib_4
    libusb1
    portaudio
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qtserialport
    qt5.qtwebsockets
    boost
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9]\\.[0-9]\\.[0-9])$"
    ];
  };

  meta = {
    description = "Weak-signal digital communication modes for amateur radio";
    longDescription = ''
      WSJT-X implements communication protocols or "modes" called FT4, FT8, JT4,
      JT9, JT65, QRA64, ISCAT, MSK144, and WSPR, as well as one called Echo for
      detecting and measuring your own radio signals reflected from the Moon.
      These modes were all designed for making reliable, confirmed ham radio
      contacts under extreme weak-signal conditions.
    '';
    homepage = "https://wsjt.sourceforge.io";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lasandell
      numinit
    ];
  };
})
