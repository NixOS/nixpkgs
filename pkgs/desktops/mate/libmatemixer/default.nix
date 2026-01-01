{
  config,
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  glib,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  udev,
  pulseaudioSupport ? config.pulseaudio or true,
  libpulseaudio,
  ossSupport ? false,
<<<<<<< HEAD
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "libmatemixer";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/libmatemixer-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "XXO5Ijl/YGiOPJUw61MrzkbDDiYtsbU1L6MsQNhwoMc=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    glib
  ]
  ++ lib.optionals alsaSupport [
    alsa-lib
    udev
  ]
  ++ lib.optionals pulseaudioSupport [
    libpulseaudio
  ];

  configureFlags = lib.optional ossSupport "--enable-oss";

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/libmatemixer";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Mixer library for MATE";
    homepage = "https://github.com/mate-desktop/libmatemixer";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Mixer library for MATE";
    homepage = "https://github.com/mate-desktop/libmatemixer";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
