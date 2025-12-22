{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "toktop";
  version = "0.1.5";
  src = fetchFromGitHub {
    owner = "htin1";
    hash = "sha256-WsOyLaVrfEoIIRThGfdwpAeFOODSjuhIaM2opn+Vlf0=";
    repo = "toktop";
    tag = "v${finalAttrs.version}";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = 1;
    PKG_CONFIG_PATH = "${lib.getDev openssl}/lib/pkgconfig";
  };

  cargoHash = "sha256-/0WDmw8T4Mz1yGSaddpmqdGlRrQXpo7UZhHmT+lMpMk=";
  meta = {
    description = "llm usage monitor in terminal";
    homepage = "https://crates.io/crates/toktop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ valyntyler ];
  };
})
