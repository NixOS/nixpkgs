{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libdeflate-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "0kmp38s7vahvbgzzhs5v0bfyjgas1in7jn69gpyh70kl08279ly0";
  };

  postPatch = ''
    substituteInPlace Makefile --replace /usr $out
  '';

  configurePhase = ''
    make programs/config.h
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Fast DEFLATE/zlib/gzip compressor and decompressor";
    license = licenses.mit;
    homepage = https://github.com/ebiggers/libdeflate;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
