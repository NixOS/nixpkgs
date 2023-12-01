{ config
, lib
, stdenv
, fetchurl
, pkg-config
, gettext
, glib
, alsaSupport ? stdenv.isLinux
, alsa-lib
, pulseaudioSupport ? config.pulseaudio or true
, libpulseaudio
, ossSupport ? false
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "libmatemixer";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "SWD1mmufr4KgHUpLjMJgtIaN2ZHv1Kmxe10KFaHToa4=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    glib
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional pulseaudioSupport libpulseaudio;

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
