{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "nv-codec-headers";
  version = "9.1.23.1";

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n${version}";
    sha256 = "1xfvb3mhz6wfx9c732888xa82ivaig903lhvvrqqzs31qfznsplh";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "FFmpeg version of headers for NVENC";
    homepage = "https://ffmpeg.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.MP2E ];
    platforms = stdenv.lib.platforms.all;
  };
}
