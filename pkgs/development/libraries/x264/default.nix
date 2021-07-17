{ stdenv, lib, fetchFromGitLab, nasm
, enableShared ? !stdenv.hostPlatform.isStatic
 }:

stdenv.mkDerivation rec {
  pname = "x264";
  version = "unstable-2021-04-12";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "55d517bc4569272a2c9a367a4106c234aba2ffbc";
    sha256 = "1nk774zwr742vhwmjnnhkrxqn5p1jdbaxjrrp131hdbgjpamcdl6";
  };

  # Upstream ./configure greps for (-mcpu|-march|-mfpu) in CFLAGS, which in nix
  # is put in the cc wrapper anyway.
  patches = [ ./disable-arm-neon-default.patch ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" ];

  preConfigure = lib.optionalString (stdenv.buildPlatform.isx86_64 || stdenv.hostPlatform.isi686) ''
    # `AS' is set to the binutils assembler, but we need nasm
    unset AS
  '' + lib.optionalString (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isAarch32) ''
    export AS=$CC
  '';

  configureFlags = lib.optional enableShared "--enable-shared"
    ++ lib.optional (!stdenv.isi686) "--enable-pic"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "--cross-prefix=${stdenv.cc.targetPrefix}";

  nativeBuildInputs = lib.optional (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isi686) nasm;

  meta = with lib; {
    description = "Library for encoding H264/AVC video streams";
    homepage    = "http://www.videolan.org/developers/x264.html";
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ spwhitt tadeokondrak ];
  };
}
