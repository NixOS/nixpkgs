{ lib, stdenv, fetchFromGitHub, fetchpatch, fixDarwinDylibNames, snappy, cmake
, static ? stdenv.hostPlatform.isStatic }:

stdenv.mkDerivation rec {
  pname = "leveldb";
  version = "1.23";

  src = fetchFromGitHub {
    owner = "google";
    repo = "leveldb";
    rev = "${version}";
    sha256 = "sha256-RL+dfSFZZzWvUobSqiPbuC4nDiGzjIIukbVJZRacHbI=";
  };

  patches = [
    # Re-enable RTTI. Needed for e.g. Ceph to compile properly.
    # See https://github.com/NixOS/nixpkgs/issues/147801,
    # https://github.com/google/leveldb/issues/731,
    # https://lists.ceph.io/hyperkitty/list/dev@ceph.io/thread/K4OSAA4AJS2V7FQI6GNCKCK3IRQDBQRS/.
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/leveldb/raw/e8178670c664e952fdd00f1fc6e3eb28b2c5b6a8/f/0006-revert-no-rtti.patch";
      sha256 = "sha256-d2YAV8O+1VKu3WwgNsWw6Cxg5sUUR+xOlJtA7pTcigQ=";
    })
  ];

  outputs = [ "out" "dev" ];

  buildInputs = [ snappy ];

  nativeBuildInputs = lib.optional stdenv.isDarwin fixDarwinDylibNames ++ [ cmake ];

  doCheck = true;

  buildFlags = [ "all" ];

  # NOTE: disabling tests due to gtest issue
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
    "-DLEVELDB_BUILD_TESTS=OFF"
    "-DLEVELDB_BUILD_BENCHMARKS=OFF"
  ];

  postInstall = ''
    substituteInPlace "$out"/lib/cmake/leveldb/leveldbTargets.cmake \
      --replace 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES "'$dev'"'
    mkdir -p $dev/lib/pkgconfig
    cat <<EOF > $dev/lib/pkgconfig/leveldb.pc
      Name: leveldb
      Description: Fast and lightweight key/value database library by Google.
      Version: ${version}
      Libs: -L$out/lib -lleveldb
      Cflags: -I$dev/include
    EOF
  '';

  meta = with lib; {
    homepage = "https://github.com/google/leveldb";
    description = "Fast and lightweight key/value database library by Google";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
