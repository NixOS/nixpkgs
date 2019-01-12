{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "nv-codec-headers-${version}";
  version = "8.2.15.6";

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n${version}";
    sha256 = "0216ww8byjxz639kagyw0mr9vxxwj89xdnj448d579vjr54jychv";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "FFmpeg version of headers for NVENC";
    homepage = http://ffmpeg.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.MP2E ];
    platforms = stdenv.lib.platforms.all;
  };
}
