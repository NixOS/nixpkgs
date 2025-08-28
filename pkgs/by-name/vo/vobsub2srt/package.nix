{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libtiff,
  makeWrapper,
  pkg-config,
  tesseract3,
}:

stdenv.mkDerivation {
  pname = "vobsub2srt";
  version = "unstable-2014-08-17";

  src = fetchFromGitHub {
    owner = "ruediger";
    repo = "VobSub2SRT";
    rev = "a6abbd61127a6392d420bbbebdf7612608c943c2";
    sha256 = "sha256-i6V2Owb8GcTcWowgb/BmdupOSFsYiCF2SbC9hXa26uY=";
  };

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [ "-std=c++11" ]);

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs = [ libtiff ];
  propagatedBuildInputs = [ tesseract3 ];
  postInstall = ''
    wrapProgram $out/bin/vobsub2srt --add-flags "--tesseract-data ${tesseract3}/share/tessdata"
  '';

  meta = {
    homepage = "https://github.com/ruediger/VobSub2SRT";
    description = "Converts VobSub subtitles into SRT subtitles";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ttuegel ];
    mainProgram = "vobsub2srt";
  };
}
