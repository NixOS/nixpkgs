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
  version = "1.27.1612021-unstable-2026-01-05";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "a09a9bb72a55789ca686d7242b1095f27e820da7";
    sha256 = "sha256-6mJ4qC+ggghJX+MTVIqEQK0Gm7Fgp49i9OT8xAJfsr8=";
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
