{ stdenv, lib, fetchFromGitHub, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "sha256-P7YbuhP2/zJCpE9dxZev1yy5oda8WKAHY84ZLTL8gVs=";
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
