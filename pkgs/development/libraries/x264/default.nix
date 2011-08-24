{stdenv, fetchurl, yasm}:

stdenv.mkDerivation rec {
  version = "snapshot-20110724-2245-stable";
  name = "x264-${version}";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-${version}.tar.bz2";
    sha256 = "07bylkh8cwcmj01sr41hhrvfbciyixhw1irdpj01kz9d0h8dhhpz";
  };

  patchPhase = ''
    sed -i s,/bin/bash,${stdenv.shell}, configure version.sh
  '';

  configureFlags = [ "--enable-shared" ]
    ++ stdenv.lib.optional (!stdenv.isi686) "--enable-pic";

  buildInputs = [ yasm ];

  meta = { 
    description = "library for encoding H264/AVC video streams";
    homepage = http://www.videolan.org/developers/x264.html;
    license = "GPL";
  };
}
