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
  version = "1.27.1612021-unstable-2026-11-02";

  src = fetchFromGitHub {
    owner = "meta";
    repo = "wdt";
    rev = "b9ec88a4fb6517a584e6d4127c05c7af6104a28a";
    hash = "sha256-xH/KsJtF44csQTPitGUbpvjRai2s7p061XYtv3vUBZg=";
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
  # https://github.com/meta/wdt/blob/43319e59d0c77092468367cdadab37d12d7a2383/CMakeLists.txt#L238
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

  # We must increase the pinned C++ standard since headers from Folly
  # v2026.07.27.00 require at least C++20
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "find_package(Boost COMPONENTS system filesystem REQUIRED)" \
        "find_package(Boost COMPONENTS filesystem REQUIRED)" \
      --replace-fail "set(CMAKE_CXX_STANDARD 17)" "set(CMAKE_CXX_STANDARD 20)"
  '';

  meta = {
    description = "Warp speed Data Transfer";
    homepage = "https://github.com/meta/wdt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
