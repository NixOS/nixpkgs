{ lib
, stdenv
, fetchFromGitHub
, cmake
, zlib
}:

stdenv.mkDerivation rec {
  pname = "taglib";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "taglib";
    repo = "taglib";
    rev = "v${version}";
    hash = "sha256-QX0EpHGT36UsgIfRf5iALnwxe0jjLpZvCTbk8vSMFF4=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    # Workaround unconditional ${prefix} until upstream is fixed:
    #   https://github.com/taglib/taglib/issues/1098
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = with lib; {
    homepage = "https://taglib.org/";
    description = "A library for reading and editing audio file metadata";
    longDescription = ''
      TagLib is a library for reading and editing the meta-data of several
      popular audio formats. Currently it supports both ID3v1 and ID3v2 for MP3
      files, Ogg Vorbis comments and ID3 tags and Vorbis comments in FLAC, MPC,
      Speex, WavPack, TrueAudio, WAV, AIFF, MP4 and ASF files.
    '';
    license = with licenses; [ lgpl3 mpl11 ];
    maintainers = with maintainers; [ ttuegel ];
  };
}
