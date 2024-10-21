{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "versatiles";
  version = "0.12.9"; # When updating: Replace with current version

  src = fetchFromGitHub {
    owner = "versatiles-org";
    repo = "versatiles-rs";
    rev = "a1896bc1e639ec46bd00f89bffaba9181614515a"; # When updating: Replace with long commit hash of new version
    hash = "sha256-oyTsL+oqpYxIlG7C7yS94TY8c8v15NbQ/U3fJdEEVDQ="; # When updating: Use `lib.fakeHash` for recomputing the hash once. Run: 'nix-build -A versatiles'. Swap with new hash and proceed.
  };

  cargoHash = "sha256-SeTDfxoIVTWXI1miolHthIhgBWDtFtPEMWGjmFl/f4o="; # When updating: Same as above

  checkFlags = [
    # Skip tests that require network access
    "--skip tools::convert::tests::test_remote1"
    "--skip tools::convert::tests::test_remote2"
    "--skip tools::probe::tests::test_remote"
    "--skip tools::serve::tests::test_remote"
    "--skip utils::io::data_reader_http"
    "--skip utils::io::data_reader_http::tests::read_range_git"
    "--skip utils::io::data_reader_http::tests::read_range_googleapis"
  ];

  meta = with lib; {
    description = "VersaTiles - A toolbox for converting, checking and serving map tiles in various formats.";
    longDescription = ''
      VersaTiles is a Rust-based project designed for processing and serving tile data efficiently.
      It supports multiple tile formats and offers various functionalities for handling tile data.
    '';
    homepage = "https://versatiles.org/";
    downloadPage = "https://github.com/versatiles-org/versatiles-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ wilhelmines ];
    mainProgram = "versatiles";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "x86_64-windows"
    ];
  };
}
