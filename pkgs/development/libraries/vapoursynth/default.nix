{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook
, zimg, libass, python3, libiconv
, ApplicationServices, nasm
, ocrSupport ?  false, tesseract
, imwriSupport? true,  imagemagick7
}:

assert ocrSupport   -> tesseract != null;
assert imwriSupport -> imagemagick7 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "vapoursynth-${version}";
  version = "R40";

  src = fetchFromGitHub {
    owner  = "vapoursynth";
    repo   = "vapoursynth";
    rev    = version;
    sha256 = "1ycc3fdhhryp7hap80z3qmh89br31kcswzp8ai3wlc07zfvcrfck";
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
    platforms   = platforms.unix;
    maintainers = with maintainers; [ rnhmjoj ];
  };

}
