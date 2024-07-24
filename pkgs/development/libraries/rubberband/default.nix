{ lib, stdenv, fetchurl, pkg-config, libsamplerate, libsndfile, fftw
, lv2, jdk_headless
, vamp-plugin-sdk, ladspaH, meson, ninja, darwin }:

stdenv.mkDerivation rec {
  pname = "rubberband";
  version = "3.3.0";

  src = fetchurl {
    url = "https://breakfastquay.com/files/releases/${pname}-${version}.tar.bz2";
    hash = "sha256-2e+J4rjvn4WxOsPC+uww4grPLJ86nIxFzmN/K8leV2w=";
  };

  nativeBuildInputs = [ pkg-config meson ninja jdk_headless ];
  buildInputs = [ libsamplerate libsndfile fftw vamp-plugin-sdk ladspaH lv2 ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [Accelerate CoreGraphics CoreVideo]);
  makeFlags = [ "AR:=$(AR)" ];

  # TODO: package boost-test, so we can run the test suite. (Currently it fails
  # to find libboost_unit_test_framework.a.)
  mesonFlags = [ "-Dtests=disabled" ];
  doCheck = false;

  meta = with lib; {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = "https://breakfastquay.com/rubberband/";
    # commercial license available as well, see homepage. You'll get some more optimized routines
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.all;
  };
}
