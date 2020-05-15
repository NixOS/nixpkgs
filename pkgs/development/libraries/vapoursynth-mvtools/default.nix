{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook,
  vapoursynth, nasm, fftwFloat
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-mvtools";
  version = "22";

  src = fetchFromGitHub {
    owner  = "dubhater";
    repo   = "vapoursynth-mvtools";
    rev    = "v${version}";
    sha256 = "11al56liaahkr3819iynq83k8n42wvijfv2ja5fsjdl6j4zfzpbr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoreconfHook
    nasm vapoursynth fftwFloat
  ];

  configureFlags = [ "--libdir=$(out)/lib/vapoursynth" ];

  meta = with stdenv.lib; {
    description = "A set of filters for motion estimation and compensation";
    homepage = "https://github.com/dubhater/vapoursynth-mvtools";
    license  = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
