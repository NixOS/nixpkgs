{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tracel-cli";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "tracel-ai";
    repo = "tracel-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j+qnzz0tUdOtJJ00f4yWJZ5EK6hMRTtFlQR6arnD1Oo=";
  };

  __structuredAttrs = true;

  buildAndTestSubdir = "crates/tracel-cli";

  cargoHash = "sha256-Pg7hPw2yx8o/ncbLg3ZgPzLbzhcb8ih74XCv227OWwc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    # Pulled in by flate2
    zlib
  ];

  # For tests that compare stdout stuff
  env.NO_COLOR = "1";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for interacting with Burn Central";
    longDescription = ''
      The Burn Central CLI (burn) is the command-line tool for interacting
      with Burn Central, the centralized platform for experiment tracking,
      model sharing, and deployment for Burn users.
    '';
    homepage = "https://github.com/tracel-ai/tracel-cli";
    changelog = "https://github.com/tracel-ai/tracel-cli/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ kilyanni ];
    mainProgram = "tracel";
  };
})
