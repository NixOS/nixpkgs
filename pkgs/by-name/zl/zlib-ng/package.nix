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
    rev = finalAttrs.version;
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

  env = lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
    # This can be removed when we switch to libcxx from llvm 20
    # https://github.com/llvm/llvm-project/pull/122361
    NIX_CFLAGS_COMPILE = "-D_XOPEN_SOURCE=700";
  };

  buildInputs = [ gtest ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=/"
    "-DBUILD_SHARED_LIBS=ON"
    "-DINSTALL_UTILS=OFF"
  ]
  ++ lib.optionals withZlibCompat [ "-DZLIB_COMPAT=ON" ];

  meta = {
    description = "Zlib data compression library for the next generation systems";
    homepage = "https://github.com/zlib-ng/zlib-ng";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
