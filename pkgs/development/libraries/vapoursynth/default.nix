{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, makeWrapper
, zimg, libass, python3, libiconv
, ApplicationServices, nasm
, ocrSupport ?  false, tesseract ? null
, imwriSupport? true,  imagemagick7 ? null
}:

assert ocrSupport   -> tesseract != null;
assert imwriSupport -> imagemagick7 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "vapoursynth";
  version = "R47.2";

  src = fetchFromGitHub {
    owner  = "vapoursynth";
    repo   = "vapoursynth";
    rev    = version;
    sha256 = "004h0vvih7dlhkcz6l2786pf7s04qhiv0bii4gjx23cxyklglh9i";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook nasm makeWrapper ];
  buildInputs = [
    zimg libass
    (python3.withPackages (ps: with ps; [ sphinx cython ]))
  ] ++ optionals stdenv.isDarwin [ libiconv ApplicationServices ]
    ++ optional ocrSupport   tesseract
    ++ optional imwriSupport imagemagick7;

  configureFlags = [
    (optionalString (!ocrSupport)   "--disable-ocr")
    (optionalString (!imwriSupport) "--disable-imwri")
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/vspipe \
        --prefix PYTHONPATH : $out/${python3.sitePackages}
  '';

  meta = with stdenv.lib; {
    description = "A video processing framework with the future in mind";
    homepage    = http://www.vapoursynth.com/;
    license     = licenses.lgpl21;
    platforms   = platforms.x86_64;
    maintainers = with maintainers; [ rnhmjoj tadeokondrak ];
  };

}
