{ stdenv, lib, fetchurl, nasm }:

stdenv.mkDerivation rec {
  pname = "x264";
  version = "20190517-2245";

  src = fetchurl {
    url = "https://download.videolan.org/x264/snapshots/x264-snapshot-${version}-stable.tar.bz2";
    sha256 = "1xv41z04km3rf374xk3ny7v8ibr211ph0j5am0909ln63mphc48f";
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
