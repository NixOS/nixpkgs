{
  lib,
  stdenv,
  fetchFromGitHub,
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
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-jd/PCXhbCZGMsoXjekbeqMSRVBJAy4INdpkTbZFjVO0=";
  };

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
