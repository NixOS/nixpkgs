{ lib
, stdenv
, boost
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "msgpack";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "refs/tags/cpp-${version}";
    hash = "sha256-p0eLd0fHhsgnRomubYadumMNiC2itdePJC9B55m49LI=";
  };

  nativeBuildInputs = [
    boost
    cmake
  ];

  cmakeFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DMSGPACK_BUILD_EXAMPLES=OFF"
  ];

  meta = with lib; {
    description = "MessagePack implementation for C and C++";
    homepage = "https://msgpack.org";
    changelog = "https://github.com/msgpack/msgpack-c/releases/tag/cpp-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ redbaron ];
    platforms = platforms.all;
  };
}
