{ lib
, stdenv
, fetchFromGitHub
, fixDarwinDylibNames
, pkgsStatic
, cmake
}:
stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.18";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "sha256-dWSDAYn36GDtkghmouGhHzxpa6EVwCslIPqejlLMZNM=";
  };

  cmakeFlags = lib.optionals stdenv.hostPlatform.isStatic [ "-DLIBDEFLATE_BUILD_SHARED_LIB=OFF" ];

  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  passthru.tests.static = pkgsStatic.libdeflate;

  meta = with lib; {
    description = "Fast DEFLATE/zlib/gzip compressor and decompressor";
    license = licenses.mit;
    homepage = "https://github.com/ebiggers/libdeflate";
    changelog = "https://github.com/ebiggers/libdeflate/blob/v${version}/NEWS.md";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej kaction ];
  };
}
