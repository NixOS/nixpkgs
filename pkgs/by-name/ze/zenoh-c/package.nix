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
  version = "1.9.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-c";
    # tag = version;
    # Use 1.9.0 PR merge commit with up-to-date Cargo.lock file
    rev = "8858e129271f4e05bb34d8ae6df3f3d221ef5299";
    hash = "sha256-rNvtFFM9tRttuBAIrpaYTadFcUe1El7q5t7PNnMEJXA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-7xWu9wgZqDzd60buMnF9B6Y5LRkG5C2JWiG7VwgSCvU=";
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
    substituteInPlace $out/lib/pkgconfig/zenohc.pc \
      --replace-fail "\''${prefix}/" ""
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
