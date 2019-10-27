{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "019xsz5dnbpxiz29j3zqsxyi4ksjkkygi6a2zyc8fxbm8lvaa9ar";
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
