{ lib, stdenv, fetchurl, meson, ninja, gettext, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-backgrounds";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0379hngy3ap1r5kmqvmzs9r710k2c9nal2ps3hq765df4ir15j8d";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
  ];

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Background images and data for MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus cc-by-sa-40 ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
