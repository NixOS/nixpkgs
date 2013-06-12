{stdenv, fetchurl, yasm}:

stdenv.mkDerivation rec {
  version = "snapshot-20130424-2245-stable";
  name = "x264-20130424_2245";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-${version}.tar.bz2";
    sha256 = "0vzyqsgrm9k3hzka2p8ib92jl0ha8d4267r2rb3pr9gmpjaj9azk";
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
