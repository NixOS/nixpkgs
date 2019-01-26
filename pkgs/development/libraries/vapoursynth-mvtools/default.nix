{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook,
  vapoursynth, nasm, fftwFloat
}:

stdenv.mkDerivation rec {
  name = "vapoursynth-mvtools-${version}";
  version = "20";

  src = fetchFromGitHub {
    owner  = "dubhater";
    repo   = "vapoursynth-mvtools";
    rev    = "v${version}";
    sha256 = "0nbq04wbmz7xqfcfpdvgg0p8xhh2xdcwhhx5gwr4j8bm611v0npz";
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
