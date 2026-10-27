{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cargo,
  rustPlatform,
  rustc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zenoh-c";
  version = "1.10.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-c";
    tag = finalAttrs.version;
    hash = "sha256-d6M0mFgFhjMBwSdqqsPxZ22SKA29sghcc1tbD2CJvV0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-5VILqwKgQVKcQxILPFNGUWDLH5ryYeUz886JVxrUlV4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    # Those features are used by
    # https://github.com/ros2/rmw_zenoh/blob/rolling/zenoh_cpp_vendor/CMakeLists.txt
    (lib.cmakeBool "ZENOHC_BUILD_WITH_SHARED_MEMORY" true)
    (lib.cmakeBool "ZENOHC_BUILD_WITH_UNSTABLE_API" true)
    (lib.cmakeFeature "ZENOHC_CARGO_FLAGS" "--features=zenoh/transport_serial")
  ];

  nativeBuildInputs = [
    cmake
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  # ref. https://github.com/eclipse-zenoh/zenoh-c/pull/1314
  postInstall = ''
    substituteInPlace $out/lib/cmake/zenohc/zenohcConfig.cmake \
      --replace-fail "''${PACKAGE_PREFIX_DIR}" "$out"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "C API for zenoh";
    homepage = "https://github.com/eclipse-zenoh/zenoh-c";
    license = with lib.licenses; [
      asl20
      epl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
  };
})
