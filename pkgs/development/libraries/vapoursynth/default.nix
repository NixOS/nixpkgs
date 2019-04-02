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
  name = "vapoursynth-${version}";
  version = "R45.1";

  src = fetchFromGitHub {
    owner  = "vapoursynth";
    repo   = "vapoursynth";
    rev    = version;
    sha256 = "09fj4k75cksx1imivqfyr945swlr8k392kkdgzldwc4404qv82s6";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook nasm python3 makeWrapper ];
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

  enableParallelBuilding = true;

  outputs = [ "out" "dev" "python" ];

  postInstall = ''
    moveToOutput include $dev
    moveToOutput lib/${python3.libPrefix} $python
    moveToOutput bin/vspipe $python
    wrapProgram $python/bin/vspipe \
        --prefix PYTHONPATH : $(toPythonPath $python)
  '';

  meta = with stdenv.lib; {
    description = "A video processing framework with the future in mind";
    homepage    = http://www.vapoursynth.com/;
    license     = licenses.lgpl21;
    platforms   = platforms.x86_64;
    maintainers = with maintainers; [ rnhmjoj tadeokondrak ];
  };

}
