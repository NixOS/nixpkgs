{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtest,
  withZlibCompat ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zlib-ng";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "zlib-ng";
    tag = finalAttrs.version;
    hash = "sha256-6GlHCnx9dQtmViPnvHnMS+l9Z+g6M8ynrSxLhLtmAKU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "INSTALL_UTILS" false)
    (lib.cmakeBool "ZLIB_COMPAT" withZlibCompat)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "/")
  ];

  doCheck = true;
  checkInputs = [ gtest ];

  __structuredAttrs = true;

  meta = {
    description = "Zlib data compression library for the next generation systems";
    homepage = "https://github.com/zlib-ng/zlib-ng";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
