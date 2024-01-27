{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-c";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "refs/tags/c-${finalAttrs.version}";
    hash = "sha256-TfC37QKwqvHxsLPgsEqJYkb7mpRQekbntbBPV4v4FO8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DMSGPACK_BUILD_EXAMPLES=OFF" # examples are not installed even if built
  ] ++ lib.optional (!finalAttrs.finalPackage.doCheck) "-DMSGPACK_BUILD_TESTS=OFF";

  checkInputs = [
    gtest
    zlib
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "MessagePack implementation for C";
    homepage = "https://github.com/msgpack/msgpack-c";
    changelog = "https://github.com/msgpack/msgpack-c/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ nickcao ];
  };
})
