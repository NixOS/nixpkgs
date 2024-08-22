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
  version = "1.27.1612021-unstable-2024-11-14";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wdt";
    rev = "52acd2a7f4e822143662181d8cb2db98c0d72fa7";
    sha256 = "sha256-jPXAmB4E3TWJ+Np4WAxqnJM7AES5gt84NBqZFO1gJwc=";
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
