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
  version = "1.27.1612021-unstable-2025-06-12";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "5fdb967ef2618e483341bc5021c6fa5f5506a549";
    sha256 = "sha256-3RT7sM8KosrW0r/yrxa8fKz2dSjjf2684VL3ULqfkC4=";
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

  meta = with lib; {
    description = "Warp speed Data Transfer";
    homepage = "https://github.com/facebook/wdt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
