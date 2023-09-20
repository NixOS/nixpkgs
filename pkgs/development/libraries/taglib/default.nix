{ lib
, stdenv
, fetchFromGitHub
, cmake
, zlib
}:

stdenv.mkDerivation rec {
  pname = "taglib";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "taglib";
    repo = "taglib";
    rev = "v${version}";
    sha256 = "sha256-DRALRH+/7c2lBvCpLp8hop3Xxsf76F1q8L7F9qehqQA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

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
