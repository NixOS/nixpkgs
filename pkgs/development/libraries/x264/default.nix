{ stdenv, lib, fetchurl, nasm }:

stdenv.mkDerivation rec {
  pname = "x264";
  version = "20191217-2245";

  src = fetchurl {
    url = "https://download.videolan.org/x264/snapshots/x264-snapshot-${version}-stable.tar.bz2";
    sha256 = "0q214q4rhbhigyx3dfhp6d5v5gzln01cxccl153ps5ih567mqjdj";
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

  configureFlags = [ "--enable-shared" ]
    ++ stdenv.lib.optional (!stdenv.isi686) "--enable-pic"
    ++ stdenv.lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "--cross-prefix=${stdenv.cc.targetPrefix}";

  nativeBuildInputs = lib.optional (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isi686) nasm;

  meta = with stdenv.lib; {
    description = "Library for encoding H264/AVC video streams";
    homepage    = http://www.videolan.org/developers/x264.html;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ spwhitt tadeokondrak ];
  };
}
