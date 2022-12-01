{ stdenv, lib, fetchpatch, fetchFromGitHub, fixDarwinDylibNames, pkgsStatic }:

stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "sha256-P7YbuhP2/zJCpE9dxZev1yy5oda8WKAHY84ZLTL8gVs=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ebiggers/libdeflate/commit/ee4d18872bfe09a32cfd031c716b9069a04a50a0.diff";
      sha256 = "0d2lllg60zbbbch0w0qrcqijrgski8xlsy5llg3i684d66ci538a";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local $out
  '';

  makeFlags = lib.optionals stdenv.hostPlatform.isStatic [ "DISABLE_SHARED=1"];

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  configurePhase = ''
    make programs/config.h
  '';

  enableParallelBuilding = true;

  passthru.tests.static = pkgsStatic.libdeflate;
  meta = with lib; {
    description = "Fast DEFLATE/zlib/gzip compressor and decompressor";
    license = licenses.mit;
    homepage = "https://github.com/ebiggers/libdeflate";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej kaction ];
  };
}
