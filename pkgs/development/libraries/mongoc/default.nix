{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, zlib
, zstd
, icu
, cyrus_sasl
, snappy
, darwin
}:

stdenv.mkDerivation rec {
  pname = "mongoc";
  version = "1.23.5";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-gdf3+EsAIf2yfuw75bNAPlwZbi9NFhVB9Q5MmS6KSo8=";
  };

  postPatch = ''
    substituteInPlace src/libbson/CMakeLists.txt src/libmongoc/CMakeLists.txt \
      --replace "\\\''${prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
    zstd
    icu
    cyrus_sasl
    snappy
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cmakeFlags = [
    "-DBUILD_VERSION=${version}"
    "-DENABLE_UNINSTALL=OFF"
    "-DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF"
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    rm -rf src/{libmongoc,libbson}
  '';

  meta = with lib; {
    broken = stdenv.isDarwin && stdenv.isx86_64;
    description = "The official C client library for MongoDB";
    homepage = "http://mongoc.org";
    license = licenses.asl20;
    mainProgram = "mongoc-stat";
    maintainers = with maintainers; [ archer-65 ];
    platforms = platforms.all;
  };
}
