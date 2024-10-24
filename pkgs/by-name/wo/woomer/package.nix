{
  lib,
  clang,
  cmake,
  fetchFromGitHub,
  glfw3,
  libclang,
  nix-update-script,
  pkg-config,
  rustPlatform,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "woomer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "coffeeispower";
    repo = "woomer";
    rev = "refs/tags/${version}";
    hash = "sha256-puALhN54ma2KToXUF8ipaYysyayjaSp+ISZ3AgQvniw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libwayshot-0.3.2-dev" = "sha256-QETmdzA7a1XMGdMU7tUNSJzzDw/4nkH9gKZv3pP0Nwc=";
    };
  };

  nativeBuildInputs = [
    clang
    cmake
    pkg-config
  ];

  buildInputs = [
    glfw3
    wayland
  ];

  # `raylib-sys` wants to compile examples that don't exist in its crate
  doCheck = false;

  env = {
    # Force linking so libwayland-client.so can be `dlopen`'d
    CARGO_BUILD_RUSTFLAGS = toString (
      map (arg: "-C link-arg=" + arg) [
        "-Wl,--push-state,--as-needed"
        "-lwayland-client"
        "-Wl,--pop-state"
      ]
    );

    LIBCLANG_PATH = lib.getLib libclang + "/lib";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Zoomer application for Wayland inspired by tsoding's boomer";
    homepage = "https://github.com/coffeeispower/woomer";
    changelog = "https://github.com/coffeeispower/woomer/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "woomer";
    inherit (wayland.meta) platforms;
  };
}
