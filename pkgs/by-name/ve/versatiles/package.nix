{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  aws-lc,
  zstd,
  sqlite,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "versatiles";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "versatiles-org";
    repo = "versatiles-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DycA1qDcFvJHgw35NWrS6b/RSToxShf4RjQoF/pv+cQ=";
  };

  cargoHash =
    if stdenv.hostPlatform.isDarwin then
      "sha256-NyK2UcROa2GaFLVfZuNkwtjOuiXpjNvmA/7sUidTVAA="
    else
      "sha256-rcJIyU9GhUi/T2c6UkwCBurLRFare4miGZAunmBnffQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    aws-lc
    zstd
    sqlite
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  __darwinAllowLocalNetworking = true;

  # Testing only necessary for `bins`
  cargoTestFlags = [
    "--bins"
  ];

  # Skip tests that require network access
  checkFlags = [
    "--skip=tools::convert::tests::test_remote1"
    "--skip=tools::convert::tests::test_remote2"
    "--skip=tools::probe::tests::test_remote"
    "--skip=tools::serve::tests::test_config"
    "--skip=tools::serve::tests::test_remote"
    "--skip=utils::io::data_reader_http"
    "--skip=utils::io::data_reader_http::tests::read_range_git"
    "--skip=utils::io::data_reader_http::tests::read_range_googleapis"
    "--skip=io::data_reader_http::tests::read_range_git"
    "--skip=io::data_reader_http::tests::read_range_googleapis"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Skip tests that require `sysctl` (unavailable on macOS)
    "--skip=tools::mosaic_tools::assemble::cli::tests::test_parse_buffer_size"
    "--skip=tools::mosaic_tools::assemble::cli::tests::test_parse_buffer_size_boundary_percentage"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Toolbox for converting, checking and serving map tiles in various formats";
    longDescription = ''
      VersaTiles is a Rust-based project designed for processing and serving tile data efficiently.
      It supports multiple tile formats and offers various functionalities for handling tile data.
    '';
    homepage = "https://versatiles.org/";
    downloadPage = "https://github.com/versatiles-org/versatiles-rs";
    changelog = "https://github.com/versatiles-org/versatiles-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wilhelmines ];
    mainProgram = "versatiles";
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
