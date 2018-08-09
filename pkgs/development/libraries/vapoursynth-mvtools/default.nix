{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook,
  vapoursynth, yasm, fftwFloat
}:

stdenv.mkDerivation rec {
  name = "vapoursynth-mvtools-${version}";
  version = "19";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo  = "vapoursynth-mvtools";
    rev    = "v${version}";
    sha256 = "1wjwf1lgfkqz87s0j251g625mw9xmx79zzgrjyhq3wlii73m6qwp";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoreconfHook
    yasm vapoursynth fftwFloat
  ];

  configureFlags = [ "--libdir=$(out)/lib/vapoursynth" ];

  meta = with stdenv.lib; {
    description = "A set of filters for motion estimation and compensation";
    homepage = https://github.com/dubhater/vapoursynth-mvtools;
    license  = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
