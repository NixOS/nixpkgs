{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook,
  vapoursynth, yasm, fftwFloat
}:

stdenv.mkDerivation rec {
  name = "vapoursynth-mvtools-${version}";
  version = "16";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo  = "vapoursynth-mvtools";
    rev    = "48959b868c18fa8066502f957734cbd5fb9762a0";
    sha256 = "15xpqvfzhv0kcf3gyghni4flazi1mmj2iy6zw5834phqr52yg07z";
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
