{
  config,
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  glib,
  alsaSupport ? stdenv.isLinux,
  alsa-lib,
  udev,
  pulseaudioSupport ? config.pulseaudio or true,
  libpulseaudio,
  ossSupport ? false,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "libmatemixer";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "XXO5Ijl/YGiOPJUw61MrzkbDDiYtsbU1L6MsQNhwoMc=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs =
    [
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

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Mixer library for MATE";
    homepage = "https://github.com/mate-desktop/libmatemixer";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}
