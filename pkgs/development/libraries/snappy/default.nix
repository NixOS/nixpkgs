{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "snappy";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "snappy";
    rev = version;
    sha256 = "1x7r8sjmdqlqjz0xfiwdyrqpgaj5yrvrgb28ivgpvnxgar5qv6m2";
  };

  patches = [ ./disable-benchmark.patch ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DCMAKE_SKIP_BUILD_RPATH=OFF" ];

  postInstall = ''
    substituteInPlace "$out"/lib/cmake/Snappy/SnappyTargets.cmake \
      --replace 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES "'$dev'"'
  '';

  checkTarget = "test";

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://google.github.io/snappy/;
    license = licenses.bsd3;
    description = "Compression/decompression library for very high speeds";
    platforms = platforms.unix;
  };
}
