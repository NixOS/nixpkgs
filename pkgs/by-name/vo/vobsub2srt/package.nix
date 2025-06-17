{
  lib,
  gccStdenv,
  fetchFromGitHub,
  cmake,
  libtiff,
  pkg-config,
  tesseract3,
}:

gccStdenv.mkDerivation {
  pname = "vobsub2srt";
  version = "0-unstable-2017-12-18";

  src = fetchFromGitHub {
    owner = "ruediger";
    repo = "VobSub2SRT";
    rev = "0ba6e25e078a040195d7295e860cc9064bef7c2c";
    hash = "sha256-ePqvPSgI9PGE9bymRBGmaa+WcLvJihNLP0N/SU8gQIM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libtiff ];

  propagatedBuildInputs = [ tesseract3 ];

  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++11" ];

  meta = {
    homepage = "https://github.com/ruediger/VobSub2SRT";
    description = "Converts VobSub subtitles into SRT subtitles";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ttuegel ];
    mainProgram = "vobsub2srt";
  };
}
