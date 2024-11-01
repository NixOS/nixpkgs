{ config
, lib
, stdenv
, fetchFromGitHub
, alsa-lib
, autoconf
, automake
, libpulseaudio
, libtool
, pkg-config
, portaudio
, which
, pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcaudiolib";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "pcaudiolib";
    rev = finalAttrs.version;
    hash = "sha256-ZG/HBk5DHaZP/H3M01vDr3M2nP9awwsPuKpwtalz3EE=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    which
  ];

  buildInputs = [
    portaudio
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optional pulseaudioSupport libpulseaudio;

  # touch ChangeLog to avoid below error on darwin:
  # Makefile.am: error: required file './ChangeLog.md' not found
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    touch ChangeLog
  '' + ''
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/espeak-ng/pcaudiolib";
    description = "Provides a C API to different audio devices";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.unix;
  };
})
