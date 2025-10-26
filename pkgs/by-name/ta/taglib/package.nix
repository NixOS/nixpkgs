{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  utf8cpp,
  zlib,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taglib";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "taglib";
    repo = "taglib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pzsjZgtr9icfXWxsZoA5GXf9k3gh92DzJRcp87T0PVQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    zlib
    utf8cpp
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    homepage = "https://taglib.org/";
    description = "Library for reading and editing audio file metadata";
    mainProgram = "taglib-config";
    longDescription = ''
      TagLib is a library for reading and editing the meta-data of several
      popular audio formats. Currently it supports both ID3v1 and ID3v2 for MP3
      files, Ogg Vorbis comments and ID3 tags and Vorbis comments in FLAC, MPC,
      Speex, WavPack, TrueAudio, WAV, AIFF, MP4 and ASF files.
    '';
    license = with lib.licenses; [
      lgpl21Only
      mpl11
    ];
    maintainers = with lib.maintainers; [ ttuegel ];
    pkgConfigModules = [
      "taglib"
      "taglib_c"
    ];
    platforms = lib.platforms.all;
  };
})
