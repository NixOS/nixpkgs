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

stdenv.mkDerivation rec {
  pname = "vapoursynth-mvtools";
  version = "24";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-mvtools";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Set of filters for motion estimation and compensation";
    homepage = "https://github.com/dubhater/vapoursynth-mvtools";
    license = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
