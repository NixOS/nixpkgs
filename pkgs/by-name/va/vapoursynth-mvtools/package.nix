{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  vapoursynth,
  nasm,
  fftwFloat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-mvtools";
  version = "24";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-mvtools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bEifU1PPNOBr6o9D6DGIzTaG4xjygBxkQYnZxd/4SwQ=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    nasm
    vapoursynth
    fftwFloat
  ];

  configureFlags = [ "--libdir=$(out)/lib/vapoursynth" ];

  meta = {
    description = "Set of filters for motion estimation and compensation";
    homepage = "https://github.com/dubhater/vapoursynth-mvtools";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
})
