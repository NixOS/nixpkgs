{ lib, stdenv, fetchFromGitHub, fixDarwinDylibNames, snappy, cmake
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

  outputs = [ "out" "dev" ];

  buildInputs = [ snappy ];

  nativeBuildInputs = lib.optional stdenv.isDarwin fixDarwinDylibNames ++ [ cmake ];

  doCheck = true;

  buildFlags = [ "all" ];

  # NOTE: disabling tests due to gtest issue
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DLEVELDB_BUILD_TESTS=OFF"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isStatic ''
    # remove shared objects from "all" target
    sed -i '/^all:/ s/$(SHARED_LIBS) $(SHARED_PROGRAMS)//' Makefile
  '';

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
