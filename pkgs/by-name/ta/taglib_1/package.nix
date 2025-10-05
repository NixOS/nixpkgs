{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  zlib,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taglib";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "taglib";
    repo = "taglib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QX0EpHGT36UsgIfRf5iALnwxe0jjLpZvCTbk8vSMFF4=";
  };

  patches = [
    (fetchpatch {
      name = "taglib-fix-cmake-4.patch";
      url = "https://github.com/taglib/taglib/commit/967aaf7af2f4aa2e9fed0edb2cbaca98b737eebe.patch";
      hash = "sha256-GeowBwspGAmrjALaIgEgSR9uUuClKAkS/cwZ2FHltl4=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    # Workaround unconditional ${prefix} until upstream is fixed:
    #   https://github.com/taglib/taglib/issues/1098
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
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
