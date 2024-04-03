{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typstyle";
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    rev = "v${version}";
    hash = "sha256-N3dGoLGq9UxTgupowPDE6t2xK6csAPEIcI8zZ1y3gvs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-syntax-0.11.0" = "sha256-BezpRq5O89gLbpRtte539vlJ4G5yJ6VPJ8AaC7rQNc0=";
    };
  };

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

  meta = {
    changelog = "https://github.com/Enter-tainer/typstyle/blob/${src.rev}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/Enter-tainer/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
