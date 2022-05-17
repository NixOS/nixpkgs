{ lib, stdenv, fetchurl, pkg-config, libsamplerate, libsndfile, fftw
, vamp-plugin-sdk, ladspaH, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "rubberband";
  version = "2.0.2";

  src = fetchurl {
    url = "https://breakfastquay.com/files/releases/${pname}-${version}.tar.bz2";
    sha256 = "sha256-uerAJ+eXeJrplhHJ6urxw6RMyAT5yKBEGg0dJvPWvfk=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ libsamplerate libsndfile fftw vamp-plugin-sdk ladspaH ];
  makeFlags = [ "AR:=$(AR)" ];

  meta = with lib; {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = "https://breakfastquay.com/rubberband/";
    # commercial license available as well, see homepage. You'll get some more optimized routines
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
