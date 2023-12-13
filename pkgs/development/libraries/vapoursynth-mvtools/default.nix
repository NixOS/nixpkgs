{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook,
  vapoursynth, nasm, fftwFloat
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-mvtools";
  version = "23";

  src = fetchFromGitHub {
    owner  = "dubhater";
    repo   = "vapoursynth-mvtools";
    rev    = "v${version}";
    sha256 = "0lngkvxnzn82rz558nvl96rvclrck07ja1pny7wcfixp9b68ppkn";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [
    nasm vapoursynth fftwFloat
  ];

  configureFlags = [ "--libdir=$(out)/lib/vapoursynth" ];

  meta = with lib; {
    description = "A set of filters for motion estimation and compensation";
    homepage = "https://github.com/dubhater/vapoursynth-mvtools";
    license  = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
