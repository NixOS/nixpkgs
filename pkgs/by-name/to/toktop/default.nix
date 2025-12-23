{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "toktop";
  version = "0.1.4";
  src = fetchFromGitHub {
    owner = "htin1";
    hash = "sha256-7XeBDvGZDiw4syOrO13Lg9JfdgAciY0s56RYQC/aX9I=";
    repo = "toktop";
    tag = "v${finalAttrs.version}";
  };
  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  env = {
    OPENSSL_NO_VENDOR = 1;
    PKG_CONFIG_PATH = "${lib.getDev openssl}/lib/pkgconfig";
  };

  cargoHash = "sha256-F4yVcDmw9HMGzpALjwqu8J0Z7brLT8sUxpp/5bP1oHs=";
  meta = {
    description = "llm usage monitor in terminal";
    homepage = "https://crates.io/crates/toktop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [valyntyler];
  };
})
