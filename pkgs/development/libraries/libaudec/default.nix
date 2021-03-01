{ lib, stdenv, fetchFromGitHub
, libsndfile, libsamplerate
, meson, ninja, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libaudec";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "zrythm";
    repo = "libaudec";
    rev = "v${version}";
    sha256 = "1570m2dfia17dbkhd2qhx8jjihrpm7g8nnyg6n4wif4vv229s7dz";
  };

  buildInputs = [ libsndfile libsamplerate ];
  nativeBuildInputs = [ meson ninja pkg-config ];

  meta = with lib; {
    homepage = "https://www.zrythm.org";
    description = "A library for reading and resampling audio files";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
  };
}
