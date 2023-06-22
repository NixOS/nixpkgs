{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, zlib
}:

stdenv.mkDerivation rec {
  pname = "msgpack-cxx";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "refs/tags/cpp-${version}";
    hash = "sha256-p0eLd0fHhsgnRomubYadumMNiC2itdePJC9B55m49LI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
  ];

  cmakeFlags = [
    "-DMSGPACK_BUILD_DOCS=OFF" # docs are not installed even if built
  ] ++ lib.optional doCheck "-DMSGPACK_BUILD_TESTS=ON";

  checkInputs = [
    zlib
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "MessagePack implementation for C++";
    homepage = "https://github.com/msgpack/msgpack-c";
    changelog = "https://github.com/msgpack/msgpack-c/blob/${src.rev}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ nickcao ];
  };
}
