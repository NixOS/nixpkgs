{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "nv-codec-headers-${version}";
  version = "n8.1.24.2";

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "${version}";
    sha256 = "122i3f6whiz5yp44dhk73ifr1973z8vvfbg4216vb782bl8b5bam";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "ffmpeg nvidia headers for NVENC";
    homepage = http://ffmpeg.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.MP2E ];
    platforms = stdenv.lib.platforms.all;
  };
}
