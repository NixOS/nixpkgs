{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "lune";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "lune";
    rev = "v${version}";
    hash = "sha256-um8XsXT0O+gTORrJAVlTku6YURh0wljLaQ7fueF+AoQ=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rbx_binary-0.7.0" = "sha256-bwGCQMXN8VdycsyS7Om/9CKMkamAa0eBK2I2aPZ/sZs=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A standalone Luau script runtime";
    homepage = "https://github.com/filiptibell/lune";
    changelog = "https://github.com/filiptibell/lune/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ lammermann ];
  };
}
