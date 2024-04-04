{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "tinymist";
  # Please update the corresponding vscode extension when updating
  # this derivation.
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "Myriad-Dreamin";
    repo = "tinymist";
    rev = "v${version}";
    hash = "sha256-fkUL6+lNPtNONf01vxeRSj8b6bz0pW+mNFIQrV0twKM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-0.11.0" = "sha256-UzZ0tbC6Dhn178GQDyLl70WTp3h5WdaBCsEKgLisZ2M=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.frameworks.CoreServices
    darwin.apple_sdk_11_0.frameworks.Security
    darwin.apple_sdk_11_0.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "Tinymist is an integrated language service for Typst";
    homepage = "https://github.com/Myriad-Dreamin/tinymist";
    license = licenses.asl20;
    maintainers = with maintainers; [ lampros ];
    mainProgram = "tinymist";
  };
}
