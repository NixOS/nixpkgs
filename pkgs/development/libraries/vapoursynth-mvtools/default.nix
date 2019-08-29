{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook,
  vapoursynth, nasm, fftwFloat
}:

stdenv.mkDerivation rec {
  name = "vapoursynth-mvtools-${version}";
  version = "21";

  src = fetchFromGitHub {
    owner  = "dubhater";
    repo   = "vapoursynth-mvtools";
    rev    = "v${version}";
    sha256 = "0vjxpp4jmmjhcp8z81idsbgq6jyx0l4r4i32b8alnp6c9fahjh6p";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoreconfHook
    nasm vapoursynth fftwFloat
  ];

  configureFlags = [ "--libdir=$(out)/lib/vapoursynth" ];

  meta = with stdenv.lib; {
    description = "A set of filters for motion estimation and compensation";
    homepage = https://github.com/dubhater/vapoursynth-mvtools;
    license  = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
