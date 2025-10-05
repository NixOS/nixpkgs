{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  wayland,
  withNativeLibs ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "wl-clipboard-rs";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "wl-clipboard-rs";
    rev = "v${version}";
    hash = "sha256-IC19J3S4QP6eEH4zWDrTh/lQcsDzopjWGO6Vm+/cl78=";
  };

  cargoHash = "sha256-bkCrAyYxYkgeS0BSUzKipN21ZZL+RJzNyg7Mx+7V8Pg=";

  cargoBuildFlags = [
    "--package=wl-clipboard-rs"
    "--package=wl-clipboard-rs-tools"
  ]
  ++ lib.optionals withNativeLibs [
    "--features=native_lib"
  ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals withNativeLibs [
    pkg-config
  ];

  buildInputs = [
    installShellFiles
  ]
  ++ lib.optionals withNativeLibs [
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

  postInstall = ''
    installManPage target/man/wl-copy.1
    installManPage target/man/wl-paste.1

    installShellCompletion --cmd wl-copy \
      --bash target/completions/wl-copy.bash \
      --fish target/completions/wl-copy.fish \
      --zsh target/completions/_wl-copy

    installShellCompletion --cmd wl-paste \
      --bash target/completions/wl-paste.bash \
      --fish target/completions/wl-paste.fish \
      --zsh target/completions/_wl-paste
  '';

  meta = {
    description = "Command-line copy/paste utilities for Wayland, written in Rust";
    homepage = "https://github.com/YaLTeR/wl-clipboard-rs";
    changelog = "https://github.com/YaLTeR/wl-clipboard-rs/blob/v${version}/CHANGELOG.md";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "wl-clip";
    maintainers = with lib.maintainers; [
      thiagokokada
      donovanglover
    ];
  };
}
