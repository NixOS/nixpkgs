{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  opus,
  alsa-lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "tincan";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "bilalyazicioglu";
    repo = "tincan-cli";
    tag = "v0.3.3";
    hash = "sha256-Jp8HpNXLxeeVD4940Dtt+jlcvAKV4TUbbaDl9gX1v2M=";
  };

  cargoHash = "sha256-tbC3wdeGaguIXKwMCw5vRmQWoFEf4LHFOyWglu/egbc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ opus ] ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Serverless peer-to-peer voice and text chat for your terminal";
    homepage = "https://github.com/bilalyazicioglu/tincan-cli";
    changelog = "https://github.com/bilalyazicioglu/tincan-cli/releases/tag/v0.3.3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taktojakuba ];
    mainProgram = "tincan";
  };
}
