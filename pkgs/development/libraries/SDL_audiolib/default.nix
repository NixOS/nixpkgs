{ lib
, stdenv
, fetchFromGitHub
, cmake
, SDL2
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "SDL_audiolib";
  version = "unstable-2022-04-17";

  src = fetchFromGitHub {
    owner = "realnc";
    repo = "SDL_audiolib";
    rev = "908214606387ef8e49aeacf89ce848fb36f694fc";
    sha256 = "sha256-11KkwIhG1rX7yDFSj92NJRO9L2e7XZGq2gOJ54+sN/A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
  ];

  cmakeFlags = [
    "-DUSE_RESAMP_SRC=OFF"
    "-DUSE_RESAMP_SOXR=OFF"
    "-DUSE_DEC_DRFLAC=OFF"
    "-DUSE_DEC_OPENMPT=OFF"
    "-DUSE_DEC_XMP=OFF"
    "-DUSE_DEC_MODPLUG=OFF"
    "-DUSE_DEC_MPG123=OFF"
    "-DUSE_DEC_SNDFILE=OFF"
    "-DUSE_DEC_LIBVORBIS=OFF"
    "-DUSE_DEC_LIBOPUSFILE=OFF"
    "-DUSE_DEC_MUSEPACK=OFF"
    "-DUSE_DEC_FLUIDSYNTH=OFF"
    "-DUSE_DEC_BASSMIDI=OFF"
    "-DUSE_DEC_WILDMIDI=OFF"
    "-DUSE_DEC_ADLMIDI=OFF"
  ];

  meta = with lib; {
    description = "Audio decoding, resampling and mixing library for SDL";
    homepage = "https://github.com/realnc/SDL_audiolib";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
