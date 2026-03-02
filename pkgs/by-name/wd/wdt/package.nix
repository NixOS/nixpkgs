{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  folly,
  gflags,
  glog,
  openssl,
  double-conversion,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "wdt";
  version = "1.27.1612021-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "8529231cd0906876f5ed5902d026bf313fa2ef98";
    sha256 = "sha256-ylmzw5LRc7b8GfvO0HiK77fDp4k5gumDd8uvnZ/pvxs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    folly
    gflags
    glog
    openssl
    double-conversion
  ];

  # source is expected to be named wdt
  # https://github.com/facebook/wdt/blob/43319e59d0c77092468367cdadab37d12d7a2383/CMakeLists.txt#L238
  postUnpack = ''
    ln -s $sourceRoot wdt
  '';

  patches = [
    ./fix-glog-include.patch
  ];

  cmakeFlags = [
    "-DWDT_USE_SYSTEM_FOLLY=ON"
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Warp speed Data Transfer";
    homepage = "https://github.com/facebook/wdt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
