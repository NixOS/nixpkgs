{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "nv-codec-headers";
  version = "9.0.18.1";

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n${version}";
    sha256 = "0354fivb92ix341jds7a7qn3mgwimrnxbganhlhr4vayj25c3hw5";
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
