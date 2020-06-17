{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "1rhichmalqz7p1hiwvn6y0isralpbf0w5nyjp4lg0asawkxy9cww";
  };

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local $out
  '';

  configurePhase = ''
    make programs/config.h
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Fast DEFLATE/zlib/gzip compressor and decompressor";
    license = licenses.mit;
    homepage = "https://github.com/ebiggers/libdeflate";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
