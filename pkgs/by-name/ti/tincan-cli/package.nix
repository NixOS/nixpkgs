{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  libopus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tincan-cli";
  version = "0.3.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bilalyazicioglu";
    repo = "tincan-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E207+D9e7Fdj5juIEg3HxFS6XBHPvbyRGj4bO+eS1J4=";
  };

  cargoHash = "sha256-Yqtl+xqNcajegf9PnQckD2f3XLsYqS7qsx5ZQu1E4KM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libopus
  ];

  meta = {
    description = "Serverless peer-to-peer voice and text chat for your terminal";
    mainProgram = "tincan";
    homepage = "https://github.com/bilalyazicioglu/tincan-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
