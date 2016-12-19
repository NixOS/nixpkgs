{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook,
  glibc, zimg, imagemagick, libass, tesseract, yasm,
  python3
}:

stdenv.mkDerivation rec {
  name = "vapoursynth-${version}";
  version = "R35";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo  = "vapoursynth";
    rev    = "dcab1529d445776a5575859aea655e613c23c8bc";
    sha256 = "0nhpqws91b19lql2alc5pxgzfgh1wjrws0kyvir41jhfxhhjaqpi";
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
