{ lib
, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, gettext
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-backgrounds";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0379hngy3ap1r5kmqvmzs9r710k2c9nal2ps3hq765df4ir15j8d";
  };

  patches = [
    # Fix build with meson 0.61, can be removed on next update.
    # https://github.com/mate-desktop/mate-backgrounds/pull/39
    (fetchpatch {
      url = "https://github.com/mate-desktop/mate-backgrounds/commit/0096e237d420e6247a75a1c6940a818e309ac2a7.patch";
      sha256 = "HEF8VWunFO+NCG18fZA7lbE2l8pc6Z3jcD+rSZ1Jsqg=";
    })
  ];

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
