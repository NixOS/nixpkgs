{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tickrs";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = "tickrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JqX+PEob99O1VRYbw7RH6KGA1CXYyepkM9Uc5jkWlrM=";
  };

  cargoHash = "sha256-CbLRq/jsCqZ3Uz1WeEL2ARUXlmlDIrmZNTiyZRo8QLw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    changelog = "https://github.com/tarkah/tickrs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "tickrs";
  };
})
