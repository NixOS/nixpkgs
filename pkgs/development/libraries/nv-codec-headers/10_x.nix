{ lib, stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "nv-codec-headers";
  version = "10.0.26.2";

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n${version}";
    sha256 = "0n5jlwjfv5irx1if1g0n52m279bw7ab6bd3jz2v4vwg9cdzbxx85";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "FFmpeg version of headers for NVENC";
    homepage = "https://ffmpeg.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.MP2E ];
    platforms = lib.platforms.all;
  };
}
