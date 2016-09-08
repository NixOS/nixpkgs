{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook,
  glibc, zimg, imagemagick, libass, tesseract, yasm,
  python3
}:

stdenv.mkDerivation rec {
  name = "vapoursynth-${version}";
  version = "R33.1";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo  = "vapoursynth";
    rev    = "0d69d29abb3c4ba9e806958bf9c539bd6eff6852";
    sha256 = "1dbz81vgqfsb306d7891p8y25y7632y32ii3l64shr0jsq64vgsm";
  };

  buildInputs = [
    pkgconfig autoreconfHook
    zimg imagemagick libass glibc tesseract yasm
    (python3.withPackages (ps: with ps; [ sphinx cython ]))
  ];

  configureFlags = [
    "--enable-imwri"
    "--disable-static"
  ];

  meta = with stdenv.lib; {
    description = "A video processing framework with the future in mind";
    homepage = http://www.vapoursynth.com/;
    license   = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rnhmjoj ];
  };

}
