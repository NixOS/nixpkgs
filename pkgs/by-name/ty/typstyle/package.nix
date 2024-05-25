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
  version = "0.11.23";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    rev = "refs/tags/v${version}";
    hash = "sha256-42wpXEQdvVgN4aIXUp/t1jnPxqOW9ChxD0YB07PGE5o=";
  };

  cargoHash = "sha256-Zp094Hs3850foQ1oGz56qEHY1dDIkXS+iDC7hJlOET0=";

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
