{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtest,
  withZlibCompat ? false,
}:

stdenv.mkDerivation rec {
  pname = "zlib-ng";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "zlib-ng";
    rev = version;
    hash = "sha256-c2RYqHi3hj/ViBzJcYWoNib27GAbq/B1SJUfvG7CPG4=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
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
    "-DINSTALL_UTILS=ON"
  ]
  ++ lib.optionals withZlibCompat [ "-DZLIB_COMPAT=ON" ];

  meta = with lib; {
    description = "Zlib data compression library for the next generation systems";
    homepage = "https://github.com/zlib-ng/zlib-ng";
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
