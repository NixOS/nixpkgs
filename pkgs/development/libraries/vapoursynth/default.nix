{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook
, zimg, libass, python3, libiconv
, ApplicationServices, nasm
, ocrSupport ?  false, tesseract ? null
, imwriSupport? true,  imagemagick7 ? null
}:

assert ocrSupport   -> tesseract != null;
assert imwriSupport -> imagemagick7 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "vapoursynth-${version}";
  version = "R43";

  src = fetchFromGitHub {
    owner  = "vapoursynth";
    repo   = "vapoursynth";
    rev    = version;
    sha256 = "01yzxggjxr6fz3wj81z6vgp9m4jqddyk73i22kz2x620cpdgb9j9";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook nasm ];
  buildInputs = [
    zimg libass
    (python3.withPackages (ps: with ps; [ sphinx cython ]))
  ] ++ optionals stdenv.isDarwin [ libiconv ApplicationServices ]
    ++ optional ocrSupport   tesseract
    ++ optional imwriSupport imagemagick7;

  configureFlags = [
    "--disable-static"
    (optionalString (!ocrSupport)   "--disable-ocr")
    (optionalString (!imwriSupport) "--disable-imwri")
  ];

  meta = with stdenv.lib; {
    description = "A video processing framework with the future in mind";
    homepage    = http://www.vapoursynth.com/;
    license     = licenses.lgpl21;
    platforms   = platforms.x86_64;
    maintainers = with maintainers; [ rnhmjoj ];
  };

}
