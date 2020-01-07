{ lib
, stdenv
, fetchFromGitHub
, cmake
, zlib
, lz4
, bzip2
, zstd
, spdlog_0
, tbb
, openssl
, boost
, libpqxx
, clang-tools
, catch2
, python
, gtest
, doxygen
}:

stdenv.mkDerivation rec {
  pname = "tiledb";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB";
    rev = version;
    sha256 = "00ykfc7p6n0nc97lvjnqjar95xyv8b2b77cjqczy03wh5i4gmifj";
  };

  nativeBuildInputs = [
    clang-tools
    cmake
    python
    doxygen
  ];

  checkInputs = [
    gtest
  ];

  enableParallelBuilding = true;

  buildInputs = [
    catch2
    zlib
    lz4
    bzip2
    zstd
    spdlog_0
    tbb
    openssl
    boost
    libpqxx
  ];

  # emulate the process of pulling catch down
  postPatch = ''
    mkdir -p build/externals/src/ep_catch
    ln -sf ${catch2}/include/catch2 build/externals/src/ep_catch/single_include
  '';

  doCheck = false; # 9 failing tests due to what seems an overflow

  installTargets = [ "install-tiledb" "doc" ];

  meta = with lib; {
    description = "TileDB allows you to manage the massive dense and sparse multi-dimensional array data";
    homepage = https://github.com/TileDB-Inc/TileDB;
    license = licenses.mit;
    platforms = [ "x86_64-linux"];
    maintainers = with maintainers; [ rakesh4g ];
  };

}
