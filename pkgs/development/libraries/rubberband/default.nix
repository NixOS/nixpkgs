{ lib, stdenv, fetchurl, pkg-config, libsamplerate, libsndfile, fftw
, vamp-plugin-sdk, ladspaH }:

stdenv.mkDerivation rec {
  pname = "rubberband";
  version = "1.9.0";

  src = fetchurl {
    url = "https://breakfastquay.com/files/releases/${pname}-${version}.tar.bz2";
    sha256 = "4f5b9509364ea876b4052fc390c079a3ad4ab63a2683aad09662fb905c2dc026";
  };

  nativeBuildInputs = [ pkg-config ];
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
