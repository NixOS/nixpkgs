{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ulog-cpp";
  version = "0-unstable-2025-03-18";

  src = fetchFromGitHub {
    owner = "PX4";
    repo = "ulog_cpp";
    rev = "eaac352b04501a49550fe6bcf02487b818c58f84";
    hash = "sha256-KNnZNiEDvBGUWsxUEEJhqBvZ5BiwQshImHyOfETltuM=";
  };

  patches = [
    ./build-overhaul.patch # https://github.com/PX4/ulog_cpp/pull/15
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ doctest ];

  cmakeFlags = [
    (lib.cmakeBool "MAIN_PROJECT" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ library for reading and writing ULog files";
    homepage = "https://github.com/PX4/ulog_cpp";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
