{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "1v0y7998p8a8wpblnpdyk5zzvpj8pbrpzxwxmv0b0axrhaarxrf3";
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
