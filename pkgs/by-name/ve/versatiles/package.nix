{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "versatiles";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "versatiles-org";
    repo = "versatiles-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9mguuYR8sc+WpF9Jl+1O3iLkx+0jQxbckw8dUVPL3S4=";
  };

  cargoHash = "sha256-/2gQib4ui7OG0DC+gk+kpNBNznCIcm9XuY0QasIi3Mg=";

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
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

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
