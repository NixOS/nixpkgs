{ stdenv, lib, fetchFromGitLab, fetchpatch, nasm
, enableShared ? !stdenv.hostPlatform.isStatic
 }:

stdenv.mkDerivation rec {
  pname = "x264";
  version = "unstable-2021-06-13";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "5db6aa6cab1b146e07b60cc1736a01f21da01154";
    sha256 = "0swyrkz6nvajivxvrr08py0jrfcsjvpxw78xm1k5gd9xbdrxvknh";
  };

  # Upstream ./configure greps for (-mcpu|-march|-mfpu) in CFLAGS, which in nix
  # is put in the cc wrapper anyway.
  patches = [
    ./disable-arm-neon-default.patch
    (fetchpatch {
      # https://code.videolan.org/videolan/x264/-/merge_requests/114
      name = "fix-parallelism.patch";
      url = "https://code.videolan.org/videolan/x264/-/commit/e067ab0b530395f90b578f6d05ab0a225e2efdf9.patch";
      hash = "sha256-16h2IUCRjYlKI2RXYq8QyXukAdfoQxyBKsK/nI6vhRI=";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" ];

  STRINGS = if stdenv.hostPlatform.useLLVM or false
            then "${stdenv.cc.targetPrefix}llvm-strings"
            else null;

  preConfigure = lib.optionalString (stdenv.buildPlatform.isx86_64 || stdenv.hostPlatform.isi686) ''
    # `AS' is set to the binutils assembler, but we need nasm
    unset AS
  '' + lib.optionalString stdenv.hostPlatform.isAarch ''
    export AS=$CC
  '';

  configureFlags = lib.optional enableShared "--enable-shared"
    ++ lib.optional (!stdenv.isi686) "--enable-pic"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "--cross-prefix=${stdenv.cc.targetPrefix}";

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isx86 nasm;

  meta = with lib; {
    description = "Library for encoding H264/AVC video streams";
    homepage    = "http://www.videolan.org/developers/x264.html";
    license     = licenses.gpl2Plus;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ spwhitt tadeokondrak ];
  };
}
