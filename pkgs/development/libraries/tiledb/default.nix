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
}:

stdenv.mkDerivation rec {
  name = "tiledb";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB";
    rev = version;
    sha256 = "sha256:0dgvz34v1w1sd9zrxpf0is6m4k4b0nzllmwyrdbwsiclkaxqa0ha";
  };

  nativeBuildInputs = [ clang-tools cmake gtest ];

  buildInputs = [ catch2 zlib lz4 bzip2 zstd spdlog_0 tbb openssl boost libpqxx python ];

  # emulate the process of pulling catch down
  postPatch = ''
    mkdir -p build/externals/src/ep_catch
    ln -sf ${catch2}/include/catch2 build/externals/src/ep_catch/single_include
  '';

  doCheck = false;

  installTargets = "install-tiledb";

  meta = with lib; {
    description = "TileDB allows you to manage the massive dense and sparse multi-dimensional array data";
    homepage = https://github.com/TileDB-Inc/TileDB;
    license = licenses.mit;
    platforms = [ "x86_64-linux"];
    maintainers = with maintainers; [ rakesh4g ];
  };

}
