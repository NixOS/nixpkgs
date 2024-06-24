{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
, stdenv
, darwin
, nix-update-script
, testers
, typstyle
}:

rustPlatform.buildRustPackage rec {
  pname = "typstyle";
  version = "0.11.27";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    rev = "refs/tags/v${version}";
    hash = "sha256-7c2WbAEDdCmh92MXBks0AjYEEKfVFVIgU+U2x5K2jLQ=";
  };

  cargoHash = "sha256-EkMa5mudKaiGtMN2jhQ0PWZlpkpnYZUPXLAJng9+Kes=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # Disabling tests requiring network access
  checkFlags = [
    "--skip=e2e"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = typstyle; };
  };

  meta = {
    changelog = "https://github.com/Enter-tainer/typstyle/blob/${src.rev}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/Enter-tainer/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
