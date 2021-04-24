{ config, lib, stdenv, fetchurl, pkg-config, gettext, glib
, alsaSupport ? stdenv.isLinux, alsaLib
, pulseaudioSupport ? config.pulseaudio or true, libpulseaudio
, ossSupport ? false
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "libmatemixer";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1n6rq7k66zvfd6sb7h92xihh021w9hysfa4yd1mzjcbb7c62ybqx";
  };

  nativeBuildInputs = [ pkg-config gettext ];

  buildInputs = [ glib ]
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional pulseaudioSupport libpulseaudio;

  configureFlags = lib.optional ossSupport "--enable-oss";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Mixer library for MATE";
    homepage = "https://github.com/mate-desktop/libmatemixer";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
