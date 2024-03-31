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
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    rev = "v${version}";
    hash = "sha256-jAsKktTgvmZ4NKr1QpJPYjI2HRSw8CPBfJTETVyiRhg=";
  };

  cargoHash = "sha256-oLJWgF5byM3sY3Bs/wpSrBqjNg4sHDF3RIsWZBiguGI=";

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

  meta = {
    changelog = "https://github.com/Enter-tainer/typstyle/blob/${src.rev}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/Enter-tainer/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
