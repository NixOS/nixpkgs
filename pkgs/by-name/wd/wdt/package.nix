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
  version = "1.27.1612021-unstable-2025-11-18";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "635f8fd8658bd1b9149d22a61edc956c93049dfd";
    sha256 = "sha256-laNTFuFXFHzyfVVHe0iNeFHSnBU+Trakugoino7rk0Y=";
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

  meta = with lib; {
    description = "Warp speed Data Transfer";
    homepage = "https://github.com/facebook/wdt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
