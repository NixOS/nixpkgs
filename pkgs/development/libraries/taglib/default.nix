{ lib
, stdenv
, fetchFromGitHub
, cmake
, utf8cpp
, zlib
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taglib";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "taglib";
    repo = "taglib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6Vcu3+PrgL5oUy5YVJoq+Crylj/Oyx2gRLw7zfG8K+A=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib utf8cpp ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    homepage = "https://taglib.org/";
    description = "Library for reading and editing audio file metadata";
    mainProgram = "taglib-config";
    longDescription = ''
      TagLib is a library for reading and editing the meta-data of several
      popular audio formats. Currently it supports both ID3v1 and ID3v2 for MP3
      files, Ogg Vorbis comments and ID3 tags and Vorbis comments in FLAC, MPC,
      Speex, WavPack, TrueAudio, WAV, AIFF, MP4 and ASF files.
    '';
    license = with licenses; [ lgpl3 mpl11 ];
    maintainers = with maintainers; [ ttuegel ];
    pkgConfigModules = [ "taglib" "taglib_c" ];
  };
})
