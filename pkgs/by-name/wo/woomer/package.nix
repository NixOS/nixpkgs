{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  glfw3,
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

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
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
    # Not all platforms supported by Wayland are supported by the libraries
    # used here
    #
    # "unresolved import `nix::sys::memfd`"
    # https://github.com/waycrate/wayshot/blob/cb6bd68dbbe6ab70a5d8fe3bd04cc154f0631cd8/libwayshot/src/screencopy.rs#L11
    # https://github.com/nix-rust/nix/blob/0e4353a368abfcedea4ebe4345cf7604bb61d238/src/sys/mod.rs#L40-L44
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    # TODO: Remove after upstream is no longer affected by
    # https://github.com/raylib-rs/raylib-rs/issues/74
    broken = stdenv.hostPlatform.isAarch64;
  };
}
