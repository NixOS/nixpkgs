{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
  withNativeLibs ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "wl-clipboard-rs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "wl-clipboard-rs";
    rev = "v${version}";
    hash = "sha256-qwlR/PJivCgQTXe027zuQxq0iVJ3/BLg6LAD3w5tb9Y=";
  };

  cargoHash = "sha256-C3vhZq5IHtbfg2mYYdQRqaLSA0iSER8zRaKi72FCd+E=";

  cargoBuildFlags =
    [
      "--package=wl-clipboard-rs"
      "--package=wl-clipboard-rs-tools"
    ]
    ++ lib.optionals withNativeLibs [
      "--features=native_lib"
    ];

  nativeBuildInputs = lib.optionals withNativeLibs [
    pkg-config
  ];

  buildInputs = lib.optionals withNativeLibs [
    wayland
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  # Assertion errors
  checkFlags = [
    "--skip=tests::copy::copy_large"
    "--skip=tests::copy::copy_multi_no_additional_text_mime_types_test"
    "--skip=tests::copy::copy_multi_test"
    "--skip=tests::copy::copy_randomized"
    "--skip=tests::copy::copy_test"
  ];

  meta = with lib; {
    description = "Command-line copy/paste utilities for Wayland, written in Rust";
    homepage = "https://github.com/YaLTeR/wl-clipboard-rs";
    changelog = "https://github.com/YaLTeR/wl-clipboard-rs/blob/v${version}/CHANGELOG.md";
    platforms = platforms.linux;
    license = with licenses; [
      asl20
      mit
    ];
    mainProgram = "wl-clip";
    maintainers = with maintainers; [
      thiagokokada
      donovanglover
    ];
  };
}
