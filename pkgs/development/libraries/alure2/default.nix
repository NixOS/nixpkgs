{ stdenv, fetchFromGitHub, cmake, openal, libvorbis, opusfile, libsndfile }:

stdenv.mkDerivation rec {
  pname = "alure2";
  version = "unstable-2020-01-09";

  src = fetchFromGitHub {
    owner = "kcat";
    repo = "alure";
    rev = "4b7b58d3f0de444d6f26aa705704deb59145f586";
    sha256 = "0ds18hhy2wpvx498z5hcpzfqz9i60ixsi0cjihyvk20rf4qy12vg";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openal libvorbis opusfile libsndfile ];

  meta = with stdenv.lib; {
    description = "A utility library for OpenAL, providing a C++ API and managing common tasks that include file loading, caching, and streaming";
    homepage = "https://github.com/kcat/alure";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers  = with maintainers; [ McSinyx ];
  };
}
