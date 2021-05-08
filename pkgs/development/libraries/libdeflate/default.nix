{ stdenv, lib, fetchFromGitHub, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "1hnn1yd9s5h92xs72y73izak47kdz070kxkw3kyz2d3az6brfdgh";
  };

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local $out
  '';

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

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
