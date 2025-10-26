{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  vapoursynth,
  yasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-nnedi3";
  version = "12";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-nnedi3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jd/PCXhbCZGMsoXjekbeqMSRVBJAy4INdpkTbZFjVO0=";
  };

  patches = [
    (fetchpatch {
      name = "build-fixes-for-aarch64-apple-silicon.patch";
      url = "https://github.com/dubhater/vapoursynth-nnedi3/commit/15c15080ed4406929aa0d2d6a3f83ca3e26bc979.patch";
      hash = "sha256-8gNj4LixfrGq0MaIYdZuwSK/2iyh1E9s/uuSBJHZwx8=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    yasm
  ];

  configureFlags = [ "--libdir=$(out)/lib/vapoursynth" ];

  postInstall = ''
    rm -f $out/lib/vapoursynth/*.la
  '';

  meta = {
    description = "Filter for VapourSynth";
    homepage = "https://github.com/dubhater/vapoursynth-nnedi3";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = with lib.platforms; x86_64 ++ aarch64;
  };
})
