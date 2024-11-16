{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  rustPlatform,
  rustc,
  cargo,

  # flags
  enableSharedMemory ? true,
  enableUnstableApi ? true,
}:

stdenv.mkDerivation rec {
  pname = "zenoh-c";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-c";
    rev = "refs/tags/${version}";
    hash = "sha256-z+Q5GYLo8Xrf3MDALc8SUXshG1HNFSouCHrkb42BOAo=";
  };

  nativeBuildInputs = [
    cmake
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  patches = [
    # https://github.com/eclipse-zenoh/zenoh-c/pull/815
    (fetchpatch {
      name = "do-not-hardcode-linker-path.patch";
      url = "https://github.com/eclipse-zenoh/zenoh-c/commit/e90b3ffe1c3bee9a99a743913233eaa88b2d92c6.patch";
      hash = "sha256-JjG2tNU9NWna7lKyoQPTwM0NrXDDH0SjRDK+YoRJZUU=";
    })
    ./patches/cmake-absolute-install-path.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "ZENOHC_BUILD_WITH_SHARED_MEMORY" enableSharedMemory)
    (lib.cmakeBool "ZENOHC_BUILD_WITH_UNSTABLE_API" enableUnstableApi)
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Gk6f5MpXjz2ip6lX5pfgtx0OScd5lv7U5IyJFkVv1EM=";
  };

  meta = {
    description = "C bindings for the Zenoh pub/sub/query protocol";
    homepage = "https://zenoh.io";
    license = with lib.licenses; [
      asl20
      epl20
    ];
    platform = lib.platforms.all;
  };
}
