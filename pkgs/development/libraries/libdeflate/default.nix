{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libdeflate-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "1wqxwza6rwmhrsy9sw86pdcd0w742gbzsy9qxnq6kk59m6h1dbsb";
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
