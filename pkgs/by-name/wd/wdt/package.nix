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
  version = "1.27.1612021-unstable-2026-06-09";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "b3e21d71b2223fcecba58436f81a0ba7a56a6d6a";
    hash = "sha256-H7/WJV5rvgdjwFAV2FCAbmkdsqO45LsDAfCroFbxTU4=";
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
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "find_package(Boost COMPONENTS system filesystem REQUIRED)" \
        "find_package(Boost COMPONENTS filesystem REQUIRED)"
  '';

  meta = {
    description = "Warp speed Data Transfer";
    homepage = "https://github.com/facebook/wdt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
