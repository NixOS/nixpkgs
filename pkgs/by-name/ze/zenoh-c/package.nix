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
  version = "1.10.2"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-c";
    tag = finalAttrs.version;
    hash = "sha256-jlOuBT+jU+BCCf6h3jxPwvQ2hZ6IRswe+2WjwCJs56A=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-g43viDgW7MnT+0avfqTyhWXpt3eR91VuuNn9+QnKaPI=";
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
