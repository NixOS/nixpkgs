{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook,
  vapoursynth, yasm, fftwFloat
}:

stdenv.mkDerivation rec {
  name = "vapoursynth-mvtools-${version}";
  version = "17";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo  = "vapoursynth-mvtools";
    rev    = "a2f5607420af8b8e76c0a6a06a517649bfa2c187";
    sha256 = "06nq46jjyfpv74i27w2m6j64avs6shl99mk601m5h5mmdgm2mvcg";
  };

  buildInputs = [
    pkgconfig autoreconfHook
    yasm vapoursynth fftwFloat
  ];

  configureFlags = "--libdir=$(out)/lib/vapoursynth";

  meta = with stdenv.lib; {
    description = "A set of filters for motion estimation and compensation";
    homepage = https://github.com/dubhater/vapoursynth-mvtools;
    license  = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
