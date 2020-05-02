{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, makeWrapper
, zimg, libass, python3, libiconv
, ApplicationServices
, ocrSupport ?  false, tesseract ? null
, imwriSupport? true,  imagemagick7 ? null
}:

assert ocrSupport   -> tesseract != null;
assert imwriSupport -> imagemagick7 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "vapoursynth";
  version = "R49";

  src = fetchFromGitHub {
    owner  = "vapoursynth";
    repo   = "vapoursynth";
    rev    = version;
    sha256 = "1d298mlb24nlc2x7pixfbkd0qbpv4c706c32idsgpi96z1spkhvl";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook makeWrapper ];
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

  passthru = {
    # If vapoursynth is added to the build inputs of mpv and then
    # used in the wrapping of it, we want to know once inside the
    # wrapper, what python3 version was used to build vapoursynth so
    # the right python3.sitePackages will be used there.
    inherit python3;
  };

  postInstall = ''
    wrapProgram $out/bin/vspipe \
        --prefix PYTHONPATH : $out/${python3.sitePackages}
  '';

  meta = with stdenv.lib; {
    description = "A video processing framework with the future in mind";
    homepage    = "http://www.vapoursynth.com/";
    license     = licenses.lgpl21;
    platforms   = platforms.x86_64;
    maintainers = with maintainers; [ rnhmjoj tadeokondrak ];
  };

}
