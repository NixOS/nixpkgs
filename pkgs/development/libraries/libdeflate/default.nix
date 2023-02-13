{ lib
, stdenv
, fetchFromGitHub
, fixDarwinDylibNames
, pkgsStatic
, cmake
}:
stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.17";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "sha256-tKs8feGbeodOID8FPIUc/1LfBz1p0oN1Jfkv2OnA2qc=";
  };

  cmakeFlags = lib.optionals stdenv.hostPlatform.isStatic [ "-DLIBDEFLATE_BUILD_SHARED_LIB=OFF" ];

  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  passthru.tests.static = pkgsStatic.libdeflate;

  meta = with lib; {
    description = "Fast DEFLATE/zlib/gzip compressor and decompressor";
    license = licenses.mit;
    homepage = "https://github.com/ebiggers/libdeflate";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej kaction ];
  };
}
