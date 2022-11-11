{ lib, stdenv, fetchurl, pkg-config, libsamplerate, libsndfile, fftw
, vamp-plugin-sdk, ladspaH, meson, ninja, darwin }:

stdenv.mkDerivation rec {
  pname = "rubberband";
  version = "3.1.0";

  src = fetchurl {
    url = "https://breakfastquay.com/files/releases/${pname}-${version}.tar.bz2";
    sha256 = "sha256-uVp22lzbOWZ3DGARXs2Dj4QGESD4hMO/3JBPdZMeyao=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ libsamplerate libsndfile fftw vamp-plugin-sdk ladspaH ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [Accelerate CoreGraphics CoreVideo]);
  makeFlags = [ "AR:=$(AR)" ];

  meta = with lib; {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = "https://breakfastquay.com/rubberband/";
    # commercial license available as well, see homepage. You'll get some more optimized routines
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.all;
  };
}
